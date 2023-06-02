resource "tls_private_key" "default" {
  count     = var.create_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  count      = var.create_key ? 1 : 0
  key_name   = var.key_name
  public_key = tls_private_key.default[0].public_key_openssh
  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.default[0].private_key_pem}' > ./${var.key_name}.pem"
  }
}
