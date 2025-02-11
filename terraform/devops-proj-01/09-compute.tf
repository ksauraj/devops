resource "aws_instance" "pvt-1-instance" {
  ami           = aws_ami_from_instance.custom_ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.pvt-1-subnet.id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # Use the instance profile created in the iam.tf file, so that we don't get persmission issue while using aws cli
  security_groups = [aws_security_group.common-sg.id]
  key_name = aws_key_pair.aws_key_pair.key_name
      user_data = <<-EOF
                #!/bin/bash
                sudo mkdir -p /var/www/html/images /var/www/html/css /var/www/html/js
                sudo chmod -R 755 /var/www/html
                sudo chown -R apache:apache /var/www/html
                sudo -u apache aws s3 sync s3://${aws_s3_bucket.app_bucket.bucket}/ /var/www/html/
                sudo systemctl restart httpd
                EOF
  tags = {
    Name = "pvt-1-instance"
  }
  depends_on = [ aws_nat_gateway.nat_gateway, aws_ami_from_instance.custom_ami ]
}

resource "aws_instance" "pvt-2-instance" {
    ami           = aws_ami_from_instance.custom_ami.id
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.pvt-2-subnet.id
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # Use the instance profile created in the iam.tf file, so that we don't get persmission issue while using aws cli
    security_groups = [aws_security_group.common-sg.id]
    key_name = aws_key_pair.aws_key_pair.key_name
    user_data = <<-EOF
                #!/bin/bash
                sudo mkdir -p /var/www/html/images /var/www/html/css /var/www/html/js
                sudo chmod -R 755 /var/www/html
                sudo chown -R apache:apache /var/www/html
                sudo aws s3 sync s3://${aws_s3_bucket.app_bucket.bucket}/ /var/www/html/
                sudo systemctl restart httpd
                EOF
    tags = {
        Name = "pvt-2-instance"
    }  
    depends_on = [ aws_nat_gateway.nat_gateway, aws_ami_from_instance.custom_ami ]
}

resource "aws_instance" "bastion-instance" {
    ami           = "ami-0c614dee691cbbf37"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.bastion-subnet.id
    associate_public_ip_address = true
    security_groups = [aws_security_group.bastion-sg.id]
    key_name = aws_key_pair.aws_key_pair.key_name
    tags = {
        Name = "bastion-instance"
    }  
}