resource "tls_private_key" "asg" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "asg" {
  key_name   = var.key_name
  public_key = tls_private_key.asg.public_key_openssh

  tags = {
    Name = var.key_name
  }
}
