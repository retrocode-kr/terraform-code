output "env_name" {
  value = module.sec_vpc.env_name
}

output "vpc_owner_id" {
  value = module.sec_vpc.vpc_owner_id
}

output "vpc_arn" {
  value = module.sec_vpc.vpc_arn
}

output "vpc_id" {
  value = module.sec_vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.sec_vpc.vpc_cidr_block
}

output "igw_id" {
  value = module.sec_vpc.igw_id
}

output "private_subnet_ids" {
  value = module.sec_vpc.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.sec_vpc.public_subnet_ids
}
  
