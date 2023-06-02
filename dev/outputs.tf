output "env_name" {
  value = module.dev_vpc.env_name
}

output "vpc_owner_id" {
  value = module.dev_vpc.vpc_owner_id
}

output "vpc_arn" {
  value = module.dev_vpc.vpc_arn
}

output "vpc_id" {
  value = module.dev_vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.dev_vpc.vpc_cidr_block
}

output "igw_id" {
  value = module.dev_vpc.igw_id
}

output "private_subnet_ids" {
  value = module.dev_vpc.private_subnet_ids
}

output "eks_private_subnet_ids" {
  value = module.dev_vpc.eks_private_subnet_ids
}

output "public_subnet_ids" {
  value = module.dev_vpc.public_subnet_ids
}

output "eks_public_subnet_ids" {
  value = module.dev_vpc.eks_public_subnet_ids
}

output "database_subnet_ids" {
  value = module.dev_vpc.database_subnet_ids
}

output "database_subnet_group_name" {
  value = module.dev_vpc.database_subnet_group_name
}

output "natgateway_ids" {
  value = module.dev_vpc.natgateway_ids
}



###################################################################################################################
#bastion
###################################################################################################################

output "bastion_security_group_id" {
  value = module.dev_bastion.instance_sg_id
}


output "instance_profile_role_arn" {
  value       = module.dev_bastion.instance_profile_role_arn
  description = "sg of instance"
}
/* 
output "private_key_pem" {
  value       = module.dev_bastion.private_key_pem
  sensitive   = true
  description = "key pair"
} */
