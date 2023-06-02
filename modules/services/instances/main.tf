locals {
  amazon_linux_korea = "ami-0676d41f079015f32"
}


resource "aws_iam_role_policy" "instance_policy" {
  count = var.create_inline_instance_policy ? 1 : 0
  name  = "${var.instance_profile_name}-policy"
  role  = aws_iam_role.role[0].id
  #policy = var.instance_policy
  policy = data.aws_iam_policy_document.instance_inline_policy[0].json

}

resource "aws_iam_role_policy_attachment" "instance_attach_policy" {
  count      = length(var.attach_policy_arn)
  role       = aws_iam_role.role[0].id
  policy_arn = var.attach_policy_arn[count.index]
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.instance_profile_name
  role  = aws_iam_role.role[0].name
}

resource "aws_iam_role" "role" {
  count = var.create_instance_profile ? 1 : 0
  name  = "${var.instance_profile_name}-ROLE"

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

data "aws_iam_policy_document" "instance_inline_policy" {
  #for_each = var.policy_statement
  count = var.create_inline_instance_policy ? 1 : 0
  dynamic "statement" {
    for_each = try(var.inline_policy, [])
    content {
      actions = try(statement.value.actions, null)
      effect  = try(statement.value.effect, "Deny")
      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = try(principals.value.type, null)
          identifiers = try(principals.value.identifiers, [])
        }
      }
      resources = try(statement.value.resources, null)
      sid       = try(statement.value.sid, "")
    }
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


resource "aws_security_group" "instance" {

  name   = "${var.instance_name}-INSTANCE-SG"
  vpc_id = var.vpc_id
  # 테라폼 클라우드에서 output에 있는 값을 가져온다.
  #vpc_id = data.tfe_outputs.dev.values.vpc_id
  # 만약 terragrunt를 사용할 경우 vpc_id 값은 variable에서 가져온다. 대신 variable에서 terragrunt dependency로 값을 가져온다.


  # s3에서 상태 파일 아웃풋을 가져올때
  #vpc_id = data.terraform_remote_state.main.outputs.vpc_id

  tags = { "Name" : "${var.instance_name}-INSTANCE-SG" }
}

/* resource "aws_network_interface" "instance" {
  #count     = var.activate_pub_ip ? 0 : 1
  count     = var.using_eip ? 1 : 0
  subnet_id = data.aws_subnets.adopt_instance.ids[0]
  #optional requirement
  #security_groups = [aws_security_group.instance.id]
  tags = {
    "Name" = "${var.instance_name}-ENI"
  }
} */

/* resource "aws_network_interface_attachment" "main" {
  #count                = var.activate_pub_ip ? 0 : 1
  count                = var.using_eip ? 1 : 0
  instance_id          = aws_instance.main.id
  network_interface_id = aws_network_interface.instance[0].id
  device_index         = 1
} */

resource "aws_eip" "main" {
  count = var.using_eip ? 1 : 0
  vpc   = true
  #network_interface = aws_network_interface.instance[0].id
  instance = aws_instance.main.id
}

/* resource "aws_eip_association" "main" {
  count                = var.using_eip ? 1 : 0
  instance_id          = var.activate_pub_ip ? aws_instance.main.id : null
  network_interface_id = var.activate_pub_ip ? null : aws_network_interface_attachment.main[0].id

  allocation_id = aws_eip.main[0].id
} */


resource "aws_instance" "main" {
  ami                    = var.specific_instance_ami ? var.instance_ami : local.amazon_linux_korea
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.instance.id]

  #network_interface {
  #  network_interface_id = aws_network_interface.instance[0].id
  # device_index         = 0
  #}

  iam_instance_profile = var.create_instance_profile ? aws_iam_instance_profile.instance_profile[0].name : var.instance_profile_name
  #associate_public_ip_address = var.subnet_logic == "PUB" && var.activate_pub_ip ? true : false


  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      throughput            = lookup(root_block_device.value, "throughput", null)

    }
  }
  user_data = var.user_data

  tags = merge({
    "Name"  = "${var.instance_name}"
    "Logic" = var.instance_logic
    },
  var.instance_add_tags)
}

/*
resource "aws_volume_attachment" "main" {
  
}
*/
