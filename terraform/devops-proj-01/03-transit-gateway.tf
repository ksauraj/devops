resource "aws_ec2_transit_gateway" "tgw" {
  description = "Transit Gateway for connecting VPCs"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "app_vpc_attachment" {
  subnet_ids = [aws_subnet.pub-subnet.id, aws_subnet.pvt-1-subnet.id, aws_subnet.pvt-2-subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.app-vpc.id

  tags = {
    Name = "APP-VPC-TGW-Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "bastion_vpc_attachment" {
  subnet_ids         = [aws_subnet.bastion-subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.bastion-vpc.id

  tags = {
    Name = "BASTION-VPC-TGW-Attachment"
  }
}