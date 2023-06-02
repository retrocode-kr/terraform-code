output "instance_id" {
  value       = aws_instance.main.id
  description = "Id of instance"
}

output "subnet_id" {
  value       = aws_instance.main.subnet_id
  description = "Id of subnet"
}


output "instance_sg_id" {
  value       = aws_security_group.instance.id
  description = "sg of instance"
}

output "instance_profile_role_arn" {
  value       = aws_iam_role.role[0].arn
  description = "sg of instance"
}
/* 
output "private_key_pem" {
  value       = tls_private_key.default[0].private_key_pem
  sensitive   = true
  description = "value of key_pair"
} */
