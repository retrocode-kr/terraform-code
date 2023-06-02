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
    bucket         = "gs-ev-system-terraform-state"
    key            = "dev/terraform.tfstate"
    dynamodb_table = "gs-ev-system-terraform-state-locks"
    region         = "ap-northeast-2"
    encrypt        = true
    profile        = "GS_CALTEX"

  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62.0"
    }
  }
  required_version = ">= 1.2.0"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


locals {
  project_region  = data.aws_region.current.name
  project_account = data.aws_caller_identity.current.account_id
  cluster_name    = var.cluster_name
}

###################################################################################################################
#VPC
###################################################################################################################

module "dev_vpc" {
  source         = "../modules/vpc"
  project_name   = var.project_name
  env_name       = var.env_name
  vpc_name       = var.vpc_name
  vpc_cidr_block = var.vpc_cidr_block

  avaliable_zones             = var.avaliable_zones
  public_network_address      = var.public_network_address
  public_network_logic        = var.public_network_logic
  eks_public_network_address  = var.eks_public_network_address
  eks_public_network_logic    = var.eks_public_network_logic
  add_eks_public_subnet_tags  = { "karpenter.sh/discovery" = var.cluster_name }
  eks_private_network_address = var.eks_private_network_address
  eks_private_network_logic   = var.eks_private_network_logic
  add_eks_private_subnet_tags = { "karpenter.sh/discovery" = var.cluster_name }
  private_network_address     = var.private_network_address
  private_network_logic       = var.private_network_logic
  db_network_address          = var.db_network_address
  db_network_logic            = var.db_network_logic
  db_subnet_group_name        = var.db_subnet_group_name
  using_nat                   = var.using_nat
  nat_gateway_count           = var.nat_gateway_count
  nat_gateway_cidr            = var.nat_gateway_cidr

  using_transit = var.using_transit
  private_transit_gateways = [{
    cidr               = "172.12.10.0/23"
    transit_gateway_id = data.aws_ec2_transit_gateway.main.id
  }]

}




###################################################################################################################
#transit gateway
###################################################################################################################
data "aws_ec2_transit_gateway" "main" {
  filter {
    name   = "tag:Name"
    values = ["EV-SYSTEM-TGW"]
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids                                      = module.dev_vpc.private_subnet_ids
  transit_gateway_id                              = data.aws_ec2_transit_gateway.main.id
  vpc_id                                          = module.dev_vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "EV-SYSTEM-TGW-DEV-ATTACHMENT"
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
    values = [module.dev_vpc.vpc_id]
    # 테라폼 클라우드 outputs 사용시 
    #values = [data.tfe_outputs.dev.values.vpc_id]

    # s3에서 remote_state 사용시
    #values = [data.terraform_remote_state.main.outputs.vpc_id]
  }
  tags = {
    "Logic" = "PUB"
  }
}

module "dev_bastion" {
  source                  = "../modules/services/instances"
  vpc_id                  = module.dev_vpc.vpc_id
  subnet_id               = data.aws_subnets.bastion.ids[0]
  create_key              = var.create_key
  key_name                = var.key_name
  create_instance_profile = var.create_instance_profile
  using_eip               = var.using_eip
  instance_profile_name   = var.instance_profile_name
  attach_policy_arn       = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  specific_instance_ami   = var.specific_instance_ami
  instance_type           = var.instance_type
  instance_name           = var.instance_name
  subnet_logic            = var.subnet_logic
  root_block_device       = var.root_block_device
  instance_add_tags       = var.instance_add_tags

}


###################################################################################################################
# DEV Aurora
###################################################################################################################
module "dev_database_aurora" {
  source                              = "../modules/services/database"
  availability_zones                  = var.avaliable_zones
  vpc_id                              = module.dev_vpc.vpc_id
  rds_type                            = var.rds_type
  env_name                            = var.env_name
  database_subnet_group_name          = module.dev_vpc.database_subnet_group_name[0]
  name                                = var.db_cluster_name
  engine                              = var.engine
  engine_version                      = var.engine_version
  instance_class                      = var.instance_class
  instances                           = var.db_instances
  db_name                             = var.db_name
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  skip_final_snapshot                 = var.skip_final_snapshot
  username                            = var.username
  password                            = var.password
  backup_retention_period             = var.backup_retention_period
  backup_window                       = var.backup_window

  enabled_cloudwatch_logs_exports        = var.enabled_cloudwatch_logs_exports
  port                                   = var.port
  db_add_tags                            = var.db_add_tags
  create_db_cluster_parameter_group      = var.create_db_cluster_parameter_group
  db_cluster_parameter_group_name        = var.db_cluster_parameter_group_name
  db_cluster_parameter_group_family      = var.db_cluster_parameter_group_family
  db_cluster_parameter_group_description = var.db_cluster_parameter_group_description
  db_cluster_parameter_group_parameters  = var.db_cluster_parameter_group_parameters
  create_db_parameter_group              = var.create_db_parameter_group
  db_parameter_group_name                = var.db_parameter_group_name
  db_parameter_group_family              = var.db_parameter_group_family
  db_parameter_group_description         = var.db_parameter_group_description
  db_parameter_group_parameters          = var.db_parameter_group_parameters
}


###################################################################################################################
# DEV EKS key pair
###################################################################################################################
module "dev_eks_key_pair" {
  source     = "../modules/services/key-pair"
  create_key = true
  key_name   = "EV-DEV-EKS-KEY"
}

/* ###################################################################################################################
# DEV Security Group
###################################################################################################################

resource "aws_security_group" "remote_access" {
  name_prefix = "${local.cluster_name}-remote-access"
  description = "Allow remote SSH access"
  vpc_id      = module.dev_vpc.vpc_id

  ingress {
    description     = "SSH access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [module.dev_bastion.instance_sg_id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.cluster_tags, { Name = "${local.cluster_name}-remote" })
} */


###################################################################################################################
#DEV KEPCO Proxy Server
###################################################################################################################
