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
    key            = "cicd/terraform.tfstate"
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
}
######################################################################################
####VPC###############################################################################
######################################################################################
module "cicd_vpc" {
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
  nat_gateway_count       = var.nat_gateway_count
  nat_gateway_cidr        = var.nat_gateway_cidr


  using_transit = var.using_transit
  private_transit_gateways = [{
    cidr               = "172.12.32.0/19"
    transit_gateway_id = data.aws_ec2_transit_gateway.main.id
    },
    {
      cidr = "172.12.10.0/24"
  transit_gateway_id = data.aws_ec2_transit_gateway.main.id }]
}

/* 
module "prd_cicd_vpc" {
  source         = "../modules/vpc"
  project_name   = var.project_name
  env_name       = var.prd_cicd_env_name
  vpc_name       = var.prd_cicd_vpc_name
  vpc_cidr_block = var.prd_cicd_vpc_cidr_block

  avaliable_zones        = var.avaliable_zones
  public_network_address = var.prd_cicd_public_network_address
  public_network_logic   = var.prd_cicd_public_network_logic

  private_network_address = var.prd_cicd_private_network_address
  private_network_logic   = var.prd_cicd_private_network_logic
  using_nat               = var.prd_cicd_using_nat
  nat_gateway_count       = var.prd_cicd_nat_gateway_count
  nat_gateway_cidr        = var.prd_cicd_nat_gateway_cidr


  using_transit = var.prd_cicd_using_transit
  private_transit_gateways = [{
    cidr               = "172.12.32.0/19"
    transit_gateway_id = data.aws_ec2_transit_gateway.main.id
    },
    {
      cidr = "172.12.10.0/24"
  transit_gateway_id = data.aws_ec2_transit_gateway.main.id }]
}
 */


###################################################################################################################
###tranisit gateway
###################################################################################################################

data "aws_ec2_transit_gateway" "main" {
  filter {
    name   = "tag:Name"
    values = ["EV-SYSTEM-TGW"]
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids                                      = module.cicd_vpc.private_subnet_ids
  transit_gateway_id                              = data.aws_ec2_transit_gateway.main.id
  vpc_id                                          = module.cicd_vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
    Name = "EV-SYSTEM-TGW-CICD-ATTACHMENT"
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
    values = [module.cicd_vpc.vpc_id]
    # 테라폼 클라우드 outputs 사용시 
    #values = [data.tfe_outputs.dev.values.vpc_id]

    # s3에서 remote_state 사용시
    #values = [data.terraform_remote_state.main.outputs.vpc_id]
  }
  tags = {
    "Logic" = "PUB"
  }
}


module "cicd_bastion" {
  source                  = "../modules/services/instances"
  vpc_id                  = module.cicd_vpc.vpc_id
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
#DEV Jenkins
###################################################################################################################

data "aws_subnets" "jenkins" {

  filter {
    name = "availability-zone"
    #values = ["${element(var.avaliable_zones[*], count.index)}"]
    values = ["ap-northeast-2c"]
  }

  filter {
    name   = "vpc-id"
    values = [module.cicd_vpc.vpc_id]
    # 테라폼 클라우드 outputs 사용시 
    #values = [data.tfe_outputs.dev.values.vpc_id]

    # s3에서 remote_state 사용시
    #values = [data.terraform_remote_state.main.outputs.vpc_id]
  }
  tags = {
    "Logic" = "PRI"
  }
}



data "aws_subnets" "jenkins_a" {

  filter {
    name = "availability-zone"
    #values = ["${element(var.avaliable_zones[*], count.index)}"]
    values = ["ap-northeast-2a"]
  }

  filter {
    name   = "vpc-id"
    values = [module.cicd_vpc.vpc_id]
    # 테라폼 클라우드 outputs 사용시 
    #values = [data.tfe_outputs.dev.values.vpc_id]

    # s3에서 remote_state 사용시
    #values = [data.terraform_remote_state.main.outputs.vpc_id]
  }
  tags = {
    "Logic" = "PRI"
  }
}
/*
data "aws_ami" "common_jenkins" {
  owners = ["self"]
  filter {
    name   = "name"
    values = ["CICD-JENKINS-COMMON"]
  }
}
*/
data "aws_ami" "jenkins_access_not_issue" {
  owners = ["self"]
  filter {
    name   = "name"
    values = ["EV-CICD-STG-JENKINS-COPY"]
  }
}

module "cicd_jenkins" {
  source                  = "../modules/services/instances"
  vpc_id                  = module.cicd_vpc.vpc_id
  subnet_id               = data.aws_subnets.jenkins.ids[0]
  create_key              = var.jenkins_create_key
  key_name                = var.jenkins_key_name
  create_instance_profile = var.jenkins_create_instance_profile
  instance_profile_name   = var.jenkins_instance_profile_name
  attach_policy_arn       = var.jenkins_attach_policy_arn
  specific_instance_ami   = var.jenkins_specific_instance_ami
  instance_ami            = data.aws_ami.jenkins_access_not_issue.id
  instance_type           = var.jenkins_instance_type
  instance_name           = var.jenkins_instance_name
  subnet_logic            = var.jenkins_subnet_logic
  root_block_device       = var.jenkins_root_block_device
  instance_add_tags       = var.jenkins_instance_add_tags

}

module "stg_cicd_jenkins" {
  source                  = "../modules/services/instances"
  vpc_id                  = module.cicd_vpc.vpc_id
  subnet_id               = data.aws_subnets.jenkins_a.ids[0]
  create_key              = var.stg_jenkins_create_key
  key_name                = var.stg_jenkins_key_name
  create_instance_profile = var.stg_jenkins_create_instance_profile
  instance_profile_name   = var.stg_jenkins_instance_profile_name
  attach_policy_arn       = var.stg_jenkins_attach_policy_arn
  specific_instance_ami   = var.stg_jenkins_specific_instance_ami
  #instance_ami            = data.aws_ami.common_jenkins.id
  instance_ami      = "ami-04092260053308eb7"
  instance_type     = var.stg_jenkins_instance_type
  instance_name     = var.stg_jenkins_instance_name
  subnet_logic      = var.stg_jenkins_subnet_logic
  root_block_device = var.stg_jenkins_root_block_device
  instance_add_tags = var.stg_jenkins_instance_add_tags
}


module "prd_cicd_jenkins" {
  source                  = "../modules/services/instances"
  vpc_id                  = module.cicd_vpc.vpc_id
  subnet_id               = data.aws_subnets.jenkins_a.ids[0]
  create_key              = var.prd_jenkins_create_key
  key_name                = var.prd_jenkins_key_name
  create_instance_profile = var.prd_jenkins_create_instance_profile
  instance_profile_name   = var.prd_jenkins_instance_profile_name
  attach_policy_arn       = var.prd_jenkins_attach_policy_arn
  specific_instance_ami   = var.prd_jenkins_specific_instance_ami
  #instance_ami            = data.aws_ami.common_jenkins.id
  instance_ami      = "ami-04092260053308eb7"
  instance_type     = var.prd_jenkins_instance_type
  instance_name     = var.prd_jenkins_instance_name
  subnet_logic      = var.prd_jenkins_subnet_logic
  root_block_device = var.prd_jenkins_root_block_device
  instance_add_tags = var.prd_jenkins_instance_add_tags
}
###################################################################################################################
#Jenkins ALB
###################################################################################################################


data "aws_subnets" "create_elb" {

  filter {
    name = "vpc-id"
    #values = [data.terraform_remote_state.vpc.outputs.vpc_id]
    values = [module.cicd_vpc.vpc_id]
  }
  tags = {
    "Logic" = "PUB"
  }
}


data "aws_acm_certificate" "ev_test_link" {
  domain   = "*.ev-test.link"
  statuses = ["ISSUED"]
}

module "cicd_jenkins_alb" {
  source             = "../modules/services/elb"
  vpc_id             = module.cicd_vpc.vpc_id
  subnet_ids         = data.aws_subnets.create_elb.ids
  elb_name           = var.elb_name
  elb_logic          = var.elb_logic
  elb_type           = var.elb_type
  internal           = var.internal
  http_tcp_listeners = var.http_tcp_listeners
  https_listener_rules = [{
    priority             = 1
    https_listener_index = 0
    actions = [
      {
        type               = "forward"
        target_group_index = 0
      },

    ]
    conditions = [
      {
        host_headers = ["dev-jenkins.ev-test.link"]
      }
    ]
    },
    { priority             = 2
      https_listener_index = 0
      actions = [
        {
          type               = "forward"
          target_group_index = 1
        }
      ]
      conditions = [
        {
          host_headers = ["stg-jenkins.ev-test.link"]
        }
    ] },
    { priority             = 3
      https_listener_index = 0
      actions = [
        {
          type               = "forward"
          target_group_index = 2
        }
      ]
      conditions = [
        {
          host_headers = ["prd-jenkins.ev-test.link"]
        }
    ] }
  ]
  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = data.aws_acm_certificate.ev_test_link.arn
      action_type     = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "404 Not Found"
        status_code  = "404"
      }

    }
  ]
  target_groups = [
    {
      target_group_name = "EV-CICD-DEV-JENKINS-TG-8080"
      backend_port      = 8080
      backend_protocol  = "HTTP"
      target_type       = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/login"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
      }
      protocol_version = "HTTP1"

      targets = {
        jenkins = {
          target_id = module.cicd_jenkins.instance_id
          port      = 8080
        }

      }

      tags = {
        InstanceTargetGroupTag = "DEV-JENKINS-8080"
      }
    },
    {
      target_group_name = "EV-CICD-STG-JENKINS-TG-8080"
      backend_port      = 8080
      backend_protocol  = "HTTP"
      target_type       = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/login"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
      }
      protocol_version = "HTTP1"

      targets = {
        jenkins = {
          target_id = module.stg_cicd_jenkins.instance_id
          port      = 8080
        }

      }

      tags = {
        InstanceTargetGroupTag = "STG-JENKINS-8080"
      }
    },
    {
      target_group_name = "EV-CICD-PRD-JENKINS-TG-8080"
      backend_port      = 8080
      backend_protocol  = "HTTP"
      target_type       = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/login"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
      }
      protocol_version = "HTTP1"

      targets = {
        jenkins = {
          target_id = module.prd_cicd_jenkins.instance_id
          port      = 8080
        }

      }

      tags = {
        InstanceTargetGroupTag = "STG-JENKINS-8080"
      }
    }
  ]

}

###################################################################################################################
###################################################################################################################
###################################################################################################################

/* module "old_dev_cicd_jenkins" {
  source                  = "../modules/services/instances"
  vpc_id                  = module.cicd_vpc.vpc_id
  subnet_id               = data.aws_subnets.jenkins.ids[0]
  create_key              = true
  key_name                = "OLD-EV-CICD-PRD-JENKINS-KEY"
  create_instance_profile = false
  instance_profile_name   = "OLD-EV-CICD-DEV-JENKINS-PROFILE"
  attach_policy_arn       = var.jenkins_attach_policy_arn
  specific_instance_ami   = true
  instance_ami            = "ami-09cc6429f21733b34"
  instance_type           = var.jenkins_instance_type
  instance_name           = "OLD-EV-CICD-DEV-JENKINS"
  subnet_logic            = var.jenkins_subnet_logic
  root_block_device       = var.jenkins_root_block_device
  instance_add_tags       = var.jenkins_instance_add_tags
} */
