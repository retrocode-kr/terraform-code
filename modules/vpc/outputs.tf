# 프로젝트 이름 출력
output "project_name" {
  value = var.project_name
}

# 환경 이름 출력
output "env_name" {
  value = var.env_name
}

# VPC 소유자 ID 출력
output "vpc_owner_id" {
  value = aws_vpc.main.owner_id
}

# VPC ARN 출력
output "vpc_arn" {
  value       = aws_vpc.main.arn
  description = "arn of VPC"
}

# VPC ID 출력
output "vpc_id" {
  value = aws_vpc.main.id
}

# VPC CIDR 출력
output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

# Internet Gateway ID 출력
output "igw_id" {
  value = aws_internet_gateway.main.id
}


# Public Subnet ID 출력
output "public_subnet_ids" {
  value = [for key in aws_subnet.public[*].id : "${key}"]
}

# EKS Public Subnet ID 출력
output "eks_public_subnet_ids" {
  value = [for key in aws_subnet.eks_public[*].id : "${key}"]
}


# Private Subnet ID 출력
output "private_subnet_ids" {
  value = [for key in aws_subnet.private[*].id : "${key}"]
}

# EKS Private Subnet ID 출력
output "eks_private_subnet_ids" {
  value = [for key in aws_subnet.eks_private[*].id : "${key}"]
}

# Database Subnet ID 출력
output "database_subnet_ids" {
  value = [for key in aws_subnet.database[*].id : "${key}"]
}

# Public Subnet IP 출력
output "public_subnet_ips" {
  value = [for key in aws_subnet.public[*].cidr_block : "${key}"]
}

# EKS Public Subnet IP 출력
output "eks_public_subnet_ips" {
  value = [for key in aws_subnet.eks_public[*].cidr_block : "${key}"]
}

# Private Subnet IP 출력
output "private_subnet_ips" {
  value = [for key in aws_subnet.private[*].cidr_block : "${key}"]
}

# EKS Private Subnet IP 출력
output "eks_private_subnet_ips" {
  value = [for key in aws_subnet.eks_private[*].cidr_block : "${key}"]
}


# Database Subnet IP 출력
output "database_subnet_ips" {
  value = [for key in aws_subnet.database[*].cidr_block : "${key}"]
}

# Database Subnet Group Name 출력
output "database_subnet_group_name" {
  value = [for key in aws_db_subnet_group.database[*].name : "${key}"]

}

# NAT Gateway ID 출력
output "natgateway_ids" {
  value = [for key in aws_nat_gateway.this[*].id : "${key}"]
}

