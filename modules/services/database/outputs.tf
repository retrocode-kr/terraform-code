output "rds_id" {
  value       = aws_rds_cluster.aurora[*].cluster_resource_id
  description = "Id of instance"
}

output "cluster_members" {
  value = aws_rds_cluster.aurora[*].cluster_members
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "rds_cluster_endpoint" {
  value = aws_rds_cluster.aurora[*].endpoint
}


output "rds_cluster_arn" {
  value = aws_rds_cluster.aurora[*].arn
}

output "rds_cluster_instance" {
  value = aws_rds_cluster_instance.cluster_instances
}

output "rds_cluster_master_username" {
  value     = aws_rds_cluster.aurora[*].master_username
  sensitive = true
}
