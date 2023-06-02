


data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key = var.vpc_remote_state_bucket_key
    region = "ap-northeast-2"
  }
}

data "aws_subnets" "will_bastion" {
  count = length(var.bastion_instance_names)
  filter {
    name = "availability-zone"
    values = ["${element(var.specific_bastion_az[*], count.index)}"]
  }
  filter {
    name = "vpc-id"
    #values = data.aws_vpcs.main.ids
    values = [data.terraform_remote_state.vpc.outputs.vpc_id]
  }
  tags = {
    "Logic" = "PUB"
  }
}


data "aws_subnets" "cicd_subnet" {
  
  filter {
    name = "availability-zone"
    values = var.specific_cicd_az
  }
  filter {
    name = "vpc-id"
    #values = data.aws_vpcs.main.ids
    values = [data.terraform_remote_state.vpc.outputs.vpc_id]
  }
  tags = {
    "Logic" = "PUB"
  }
}

