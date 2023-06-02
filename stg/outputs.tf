output "env_name" {
  value = module.stg_vpc.env_name
}

output "vpc_owner_id" {
  value = module.stg_vpc.vpc_owner_id
}

output "vpc_arn" {
  value = module.stg_vpc.vpc_arn
}

output "vpc_id" {
  value = module.stg_vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.stg_vpc.vpc_cidr_block
}

output "igw_id" {
  value = module.stg_vpc.igw_id
}

output "private_subnet_ids" {
  value = module.stg_vpc.private_subnet_ids
}

output "eks_private_subnet_ids" {
  value = module.stg_vpc.eks_private_subnet_ids
}

output "public_subnet_ids" {
  value = module.stg_vpc.public_subnet_ids
}

output "eks_public_subnet_ids" {
  value = module.stg_vpc.eks_public_subnet_ids
}

output "database_subnet_ids" {
  value = module.stg_vpc.database_subnet_ids
}

output "database_subnet_group_name" {
  value = module.stg_vpc.database_subnet_group_name
}

output "natgateway_ids" {
  value = module.stg_vpc.natgateway_ids
}

###################################################################################################################
#bastion
###################################################################################################################

output "bastion_security_group_id" {
  value = module.stg_bastion.instance_sg_id
}


output "instance_profile_role_arn" {
  value       = module.stg_bastion.instance_profile_role_arn
  description = "sg of instance"
}
