resource "aws_instance" "custom_instance_for_ami" {
  ami           = "ami-0c614dee691cbbf37" 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.aws_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id] 
  


  tags = {
    Name = "ApacheServer"
  }

  provisioner "remote-exec" {
    inline = [
        "sudo yum update -y",
        "sudo yum install -y httpd",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./aws-key.pem") # This is the pvt key required for ssh to execute the above commands
      host        = self.public_ip
    }
  }
  depends_on = [ aws_s3_bucket.app_bucket, aws_key_pair.aws_key_pair ]

}

resource "aws_ami_from_instance" "custom_ami" {
  name                     = "custom-apache-ami"
  source_instance_id      = aws_instance.custom_instance_for_ami.id
  snapshot_without_reboot  = true
}

output "ami_id" {
  value = aws_ami_from_instance.custom_ami.id
}



# Required as we need to ssh into the instance to execute the abvoe commands
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}