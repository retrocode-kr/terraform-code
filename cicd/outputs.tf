output "project_name" {
  value = module.cicd_vpc.project_name
}

output "env_name" {
  value = module.cicd_vpc.env_name
}

output "vpc_owner_id" {
  value = module.cicd_vpc.vpc_owner_id
}

output "vpc_arn" {
  value = module.cicd_vpc.vpc_arn
}

output "vpc_id" {
  value = module.cicd_vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.cicd_vpc.vpc_cidr_block
}

output "igw_id" {
  value = module.cicd_vpc.igw_id
}

output "private_subnet_ids" {
  value = module.cicd_vpc.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.cicd_vpc.public_subnet_ids
}


###################################################################################################################
#CICD Bstaion
###################################################################################################################

output "instance_id" {
  value       = module.cicd_bastion.instance_id
  description = "Id of instance"
}

output "subnet_id" {
  value       = module.cicd_bastion.subnet_id
  description = "Id of subnet"
}

output "instance_sg_id" {
  value       = module.cicd_bastion.instance_sg_id
  description = "sg of instance"
}


###################################################################################################################
#Jenkins
###################################################################################################################
/* output "jenkins_common_ami" {
  value       = data.aws_ami.common_jenkins.id
  description = "Id of instance"
} */

output "jenkins_instance_id" {
  value       = module.cicd_jenkins.instance_id
  description = "Id of instance"
}

output "stg_jenkins_instance_id" {
  value       = module.stg_cicd_jenkins.instance_id
  description = "Id of instance"
}


output "prd_jenkins_instance_id" {
  value       = module.prd_cicd_jenkins.instance_id
  description = "Id of instance"
}

###################################################################################################################
#Jenkins ALB
###################################################################################################################
