terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

locals {
  ssh_port = "22"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
  amazon_linux_korea = "ami-0fd0765afb77bcca7"
}


resource "aws_security_group" "bastion" {
  name = "${var.project_name}-Bastion-SG"
  #vpc_id = join(" ",data.aws_vpcs.main.ids)
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}
/*
resource "aws_network_interface" "bastion" {
  #count = length(data.aws_subnets.web.ids)
  count = length(var.bastion_instance_names)
  subnet_id = "${join(" ",element(data.aws_subnets.will_bastion[*].ids, count.index))}"
  #optional requirement
  
  tags = {
    "Name" = "${var.bastion_instance_names[count.index]}-ENI"
  }
}
*/

resource "aws_instance" "bastion" {
  count = length(var.bastion_instance_names)
  ami = local.amazon_linux_korea
  instance_type = var.bastion_instance_type
  subnet_id = "${join(" ",element(data.aws_subnets.will_bastion[*].ids, count.index))}"
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name = var.bastion_key_name
  associate_public_ip_address = var.bastion_associate_public_ip_address
  #If use "associate_pulbic_ip_address" attribute, will conflict with network interface that is even false
/*
  network_interface {
    network_interface_id = "${element(aws_network_interface.bastion[*].id, count.index)}"
    device_index = 0
  }
*/
  dynamic "root_block_secirotu" {
    for_each = var.bastion_root_block_device
    content {

      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted = lookup(root_block_device.value, "encrypted", null)
      iops = lookup(root_block_device.value, "iops", null)
      kms_key_id = lookup(root_block_device.value, "kms_key_id", null)
      volume_size = lookup(root_block_device.value, "volume_size", null)
      volume_type = lookup(root_block_device.value, "volume_type", null)
      throughput = lookup(root_block_device.value, "throughput", null)
      
    }
  }
  tags = {
    "Name" = "${var.bastion_instance_names[count.index]}"
    "Logic" = "Bastion"
  }
}
/*
resource "aws_network_interface" "cicd" {
  count = (var.create_cicd_instance ? 1 : 0)
  #subnet_id = "${element(data.aws_subnets.pub.ids[*], count.index)}"
  subnet_id = join(" ",data.aws_subnets.cicd_subnet.ids)
  #optional requirement
  vpc_security_group_ids = [aws_security_group.cidd.id]
  tags = {
    "Name" = "${var.cicd_instance_names[count.index]}-ENI"
  }
}
*/
resource "aws_security_group" "cicd" {
  count = (var.create_cicd_instance ? length(var.cicd_instance_names) : 0)
  name = "${var.project_name}-CICD-SG"
  #vpc_id = join(" ",data.aws_vpcs.main.ids)
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

}

resource "aws_instance" "cicd" {
  count = (var.create_cicd_instance ? length(var.cicd_instance_names) : 0 )
  ami = local.amazon_linux_korea
  instance_type = var.cicd_instance_type
  subnet_id = "${join(" ",element(data.aws_subnets.cicd_subnet[*].ids, count.index))}"
  vpc_security_group_ids = [aws_security_group.cicd[count.index].id]
  key_name = var.cicd_key_name
  associate_public_ip_address = var.bastion_associate_public_ip_address
  
  dynamic "root_block_device" {
    for_each = var.cicd_root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted = lookup(root_block_device.value, "encrypted", null)
      iops = lookup(root_block_device.value, "iops", null)
      kms_key_id = lookup(root_block_device.value, "kms_key_id", null)
      volume_size = lookup(root_block_device.value, "volume_size", null)
      volume_type = lookup(root_block_device.value, "volume_type", null)
      throughput = lookup(root_block_device.value, "throughput", null)
      
    }
  }
  tags = {
    "Name" = "${var.cicd_instance_names[count.index]}"
    "Logic" = "CICD"
  }
}