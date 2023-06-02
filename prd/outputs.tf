output "env_name" {
  value = module.prd_vpc.env_name
}

output "vpc_owner_id" {
  value = module.prd_vpc.vpc_owner_id
}

output "vpc_arn" {
  value = module.prd_vpc.vpc_arn
}

output "vpc_id" {
  value = module.prd_vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.prd_vpc.vpc_cidr_block
}

output "igw_id" {
  value = module.prd_vpc.igw_id
}

output "private_subnet_ids" {
  value = module.prd_vpc.private_subnet_ids
}

output "eks_private_subnet_ids" {
  value = module.prd_vpc.eks_private_subnet_ids
}

output "public_subnet_ids" {
  value = module.prd_vpc.public_subnet_ids
}

output "eks_public_subnet_ids" {
  value = module.prd_vpc.eks_public_subnet_ids
}

output "database_subnet_ids" {
  value = module.prd_vpc.database_subnet_ids
}

output "database_subnet_group_name" {
  value = module.prd_vpc.database_subnet_group_name
}

output "natgateway_ids" {
  value = module.prd_vpc.natgateway_ids
}

###################################################################################################################
#bastion
###################################################################################################################

output "bastion_security_group_id" {
  value = module.prd_bastion.instance_sg_id
}


output "instance_profile_role_arn" {
  value       = module.prd_bastion.instance_profile_role_arn
  description = "sg of instance"
}
