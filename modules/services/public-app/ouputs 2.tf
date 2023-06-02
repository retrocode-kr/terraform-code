output "bastion_ec2_id" {
    value = aws_instance.bastion[*].id
    description = "The id of bastion"
}

output "cicd_ec2_id" {
    value = aws_instance.cicd[*].id
    description = "The id of cicd"
}

output "bastion_sg_id" {
  value = aws_security_group.bastion[*].id
  description = "Id of bastion Security Group"
}

output "bastion_sg_name" {
  value = aws_security_group.bastion[*].name
  description = "name of bastion Security Group"
}

output "cicd_sg_id" {
  value = aws_security_group.cicd[*].id
  description = "Id of CICD Security Group"
}

output "cicd_sg_name" {
  value = aws_security_group.cicd[*].name
  description = "Name of Cicd security Group"
}
