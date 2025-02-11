# Create a Key Pair
resource "tls_private_key" "aws_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "aws_key_pair" {
  key_name   = "aws-key-pair"
  public_key = tls_private_key.aws_ssh_key.public_key_openssh
}

# Save the Private Key Locally
resource "local_file" "private_key" {
  content  = tls_private_key.aws_ssh_key.private_key_pem
  filename = "${path.module}/aws-key.pem"
  file_permission = "0600" # Secure permissions for the private key
}
