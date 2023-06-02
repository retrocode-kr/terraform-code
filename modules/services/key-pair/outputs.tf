output "key_pair_name" {
  description = "value of key pair name"
  value       = aws_key_pair.generated_key[0].key_name
}

output "key_pair_id" {
  description = "value of key pair id"
  value       = aws_key_pair.generated_key[0].key_pair_id
}

