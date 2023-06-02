terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

locals {
  health_check_type  = var.health_check_type_elb ? "elb" : null
  amazon_linux_korea = var.ami_name
  common_tag = {
    Logic = var.instance_logic
    Name  = var.instance_name

  }

}

resource "tls_private_key" "default" {
  count     = var.create_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  count      = var.create_key ? 1 : 0
  key_name   = var.key_name
  public_key = tls_private_key.default[0].public_key_openssh
  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.default[0].private_key_pem}' > ./${var.key_name}.pem"
  }
}

resource "aws_security_group" "instances" {
  name   = "${var.project_name}-${var.instance_logic}-INSTANCE-SG"
  vpc_id = var.vpc_id
  #vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  tags = { "Name" : "${var.project_name}-${var.instance_logic}-INSTANCE-SG" }
}

resource "aws_iam_role_policy" "instance_policy" {
  count  = var.create_instance_profile ? 1 : 0
  name   = "${var.instance_profile_name}-policy"
  role   = aws_iam_role.role[0].id
  policy = var.instance_policy

}


resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.instance_profile_name
  role  = aws_iam_role.role[0].name
}

resource "aws_iam_role" "role" {
  count = var.create_instance_profile ? 1 : 0
  name  = "${var.instance_profile_name}-role"


  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_launch_template" "main" {
  name = var.launch_template_name

  block_device_mappings {
    device_name = var.device_name

    ebs {
      volume_size = var.volume_size
    }
  }

  /*
  ebs_optimized = false

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 4
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true
*/

  /*
  elastic_gpu_specifications {
    type = "test"
  }

  elastic_inference_accelerator {
    type = "eia1.medium"
  }
*/
  iam_instance_profile {
    #name = var.iam_profile
    name = var.create_instance_profile ? aws_iam_instance_profile.instance_profile[0].name : var.instance_profile_name
  }

  instance_type = var.instance_type
  image_id      = length(var.specific_ami) > 0 ? var.specific_ami : local.amazon_linux_korea

  instance_initiated_shutdown_behavior = "terminate"

  #instance_market_options {market_type = "spot"}

  key_name = var.key_name

  /*

  kernel_id = "test"

  

  license_specification {
    license_configuration_arn = "arn:aws:license-manager:eu-west-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  */
  #monitoring {enabled = true}

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = concat([aws_security_group.instances.id], var.add_security_groups_ids)
    #subnet_id = data.aws_subnets.adopt_instance.ids
  }

  #placement {}

  #ram_disk_id = "test"

  #vpc_security_group_ids = concat([aws_security_group.instances.id],var.add_security_groups_ids)

  tag_specifications {
    resource_type = "instance"

    #tags = {
    #  Logic = var.instance_logic
    #  Name  = var.instance_name

    #}
    tags = merge(
      local.common_tag,
      var.tags
    )
  }

  #user_data = filebase64("${path.module}/bash_password.sh")
  user_data = var.user_data
}


resource "aws_autoscaling_group" "main" {
  name = var.autoscaling_group_name
  #availability_zones = var.avaliable_zones
  desired_capacity    = var.autoscali_desired_capacity
  max_size            = var.autoscali_min_size
  min_size            = var.autoscali_max_size
  vpc_zone_identifier = data.aws_subnets.adopt_instance.ids

  target_group_arns = var.lb_target_group_arn

  health_check_type = local.health_check_type

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  suspended_processes = var.suspended_processes



}

