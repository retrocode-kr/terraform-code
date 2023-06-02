terraform {

  # 테라폼 클라우드를 사용할 시 
  /* 
  cloud {
    organization = "myeongjangjo"
    workspaces {
      name = "terraform"
    }
  } 
  */


  backend "s3" {
    bucket = "gs-ev-system-terraform-state"
    key    = "sec/terraform.tfstate"
    #dynamodb_table = "gs-ev-system-terraform-state-locks"
    region  = "ap-northeast-2"
    encrypt = true

  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }
  required_version = ">= 1.2.0"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  project_region  = data.aws_region.current.name
  project_account = data.aws_caller_identity.current.account_id
}

module "sec_vpc" {
  source         = "../modules/vpc"
  project_name   = var.project_name
  env_name       = var.env_name
  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block

  avaliable_zones        = var.avaliable_zones
  public_network_address = var.public_network_address
  public_network_logic   = var.public_network_logic

  private_network_address = var.private_network_address
  private_network_logic   = var.private_network_logic
  using_nat               = var.using_nat
  nat_gateway_cidr        = var.nat_gateway_cidr
  nat_gateway_count       = var.nat_gateway_count
  using_public_transit    = var.using_public_transit

  # public_transit_gateways = [{
  #   cidr               = "172.12.32.0/19"
  #   transit_gateway_id = data.aws_ec2_transit_gateway.main.id

  #   },
  #   {
  #     cidr               = "172.12.11.0/24"
  #     transit_gateway_id = data.aws_ec2_transit_gateway.main.id

  # }]
  using_transit = var.using_transit
  private_transit_gateways = [{
    cidr               = "172.12.32.0/19"
    transit_gateway_id = data.aws_ec2_transit_gateway.main.id
    },
    {
      cidr               = "172.12.11.0/24"
      transit_gateway_id = data.aws_ec2_transit_gateway.main.id
  }]

}

data "aws_ec2_transit_gateway" "main" {
  filter {
    name   = "tag:Name"
    values = ["EV-SYSTEM-TGW"]
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids                                      = module.sec_vpc.private_subnet_ids
  transit_gateway_id                              = data.aws_ec2_transit_gateway.main.id
  vpc_id                                          = module.sec_vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "EV-SYSTEM-TGW-SEC-ATTACHMENT"
  }
}


###################################################################################################################
#bastion
###################################################################################################################


data "aws_subnets" "bastion" {

  filter {
    name = "availability-zone"
    #values = ["${element(var.avaliable_zones[*], count.index)}"]
    values = ["ap-northeast-2c"]
  }

  filter {
    name   = "vpc-id"
    values = [module.sec_vpc.vpc_id]
    # 테라폼 클라우드 outputs 사용시 
    #values = [data.tfe_outputs.dev.values.vpc_id]

    # s3에서 remote_state 사용시
    #values = [data.terraform_remote_state.main.outputs.vpc_id]
  }
  tags = {
    "Logic" = "PUB"
  }
}


module "sec_bastion" {
  source                  = "../modules/services/instances"
  vpc_id                  = module.sec_vpc.vpc_id
  subnet_id               = data.aws_subnets.bastion.ids[0]
  create_key              = var.create_key
  key_name                = var.key_name
  create_instance_profile = var.create_instance_profile
  using_eip               = var.using_eip
  instance_profile_name   = var.instance_profile_name
  attach_policy_arn       = var.attach_policy_arn
  specific_instance_ami   = var.specific_instance_ami
  instance_type           = var.instance_type
  instance_name           = var.instance_name
  subnet_logic            = var.subnet_logic
  root_block_device       = var.root_block_device
  instance_add_tags       = var.instance_add_tags

}

###################################################################################################################
#cpp server amazon linux2
###################################################################################################################


data "aws_subnets" "cpp" {

  filter {
    name = "availability-zone"
    #values = ["${element(var.avaliable_zones[*], count.index)}"]
    values = ["ap-northeast-2c"]
  }

  filter {
    name   = "vpc-id"
    values = [module.sec_vpc.vpc_id]
    # 테라폼 클라우드 outputs 사용시 
    #values = [data.tfe_outputs.dev.values.vpc_id]

    # s3에서 remote_state 사용시
    #values = [data.terraform_remote_state.main.outputs.vpc_id]
  }
  tags = {
    "Logic" = "PUB"
  }
}

data "aws_eip" "main" {
  filter {
    name   = "tag:Using"
    values = ["cppserver"]
  }
}


module "cpp_server" {
  source                  = "../modules/services/instances"
  vpc_id                  = module.sec_vpc.vpc_id
  subnet_id               = data.aws_subnets.cpp.ids[0]
  create_key              = var.cpp_create_key
  key_name                = var.cpp_key_name
  create_instance_profile = var.cpp_create_instance_profile
  using_eip               = var.cpp_using_eip
  instance_profile_name   = var.cpp_instance_profile_name
  attach_policy_arn       = var.cpp_attach_policy_arn
  specific_instance_ami   = var.cpp_specific_instance_ami
  instance_ami            = var.cpp_instance_ami
  instance_type           = var.cpp_instance_type
  instance_name           = var.cpp_instance_name
  subnet_logic            = var.cpp_subnet_logic
  root_block_device       = var.cpp_root_block_device
  instance_add_tags       = var.cpp_instance_add_tags

}

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = module.cpp_server.instance_id
#   allocation_id = "eipalloc-09c559d72d7254741"
#   #allocation_id = data.aws_eip.main.id
# }


###################################################################################################################
#  agent server  - os window
###################################################################################################################

data "aws_subnets" "window_server" {

  filter {
    name = "availability-zone"
    #values = ["${element(var.avaliable_zones[*], count.index)}"]
    values = ["ap-northeast-2c"]
  }

  filter {
    name   = "vpc-id"
    values = [module.sec_vpc.vpc_id]
    # 테라폼 클라우드 outputs 사용시 
    #values = [data.tfe_outputs.dev.values.vpc_id]

    # s3에서 remote_state 사용시
    #values = [data.terraform_remote_state.main.outputs.vpc_id]
  }
  tags = {
    "Logic" = "PRI"
  }
}


module "window_server" {
  source                  = "../modules/services/instances"
  vpc_id                  = module.sec_vpc.vpc_id
  key_name                = var.window_key_name
  subnet_id               = data.aws_subnets.window_server.ids[0]
  create_key              = var.window_create_key
  create_instance_profile = var.window_create_instance_profile
  instance_profile_name   = var.window_instance_profile_name
  attach_policy_arn       = var.window_attach_policy_arn
  specific_instance_ami   = var.window_specific_instance_ami
  instance_ami            = var.window_instance_ami
  instance_type           = var.window_instance_type
  instance_name           = var.window_instance_name
  subnet_logic            = var.window_subnet_logic
  root_block_device       = var.window_root_block_device
  instance_add_tags       = var.window_instance_add_tags

}

# ###################################################################################################################
# #  agent server  - os amazon linux2
# ###################################################################################################################

data "aws_subnets" "linux_server" {

  filter {
    name = "availability-zone"
    #values = ["${element(var.avaliable_zones[*], count.index)}"]
    values = ["ap-northeast-2c"]
  }

  filter {
    name   = "vpc-id"
    values = [module.sec_vpc.vpc_id]
    # 테라폼 클라우드 outputs 사용시 
    #values = [data.tfe_outputs.dev.values.vpc_id]

    # s3에서 remote_state 사용시
    #values = [data.terraform_remote_state.main.outputs.vpc_id]
  }
  tags = {
    "Logic" = "PRI"
  }
}


module "linux_server" {
  source                  = "../modules/services/instances"
  vpc_id                  = module.sec_vpc.vpc_id
  subnet_id               = data.aws_subnets.linux_server.ids[0]
  key_name                = var.alinux_key_name
  create_key              = var.alinux_create_key
  create_instance_profile = var.alinux_create_instance_profile
  instance_profile_name   = var.alinux_instance_profile_name
  attach_policy_arn       = var.alinux_attach_policy_arn
  specific_instance_ami   = var.alinux_specific_instance_ami
  instance_ami            = var.alinux_instance_ami
  instance_type           = var.alinux_instance_type
  instance_name           = var.alinux_instance_name
  subnet_logic            = var.alinux_subnet_logic
  root_block_device       = var.alinux_root_block_device
  instance_add_tags       = var.alinux_instance_add_tags

}


