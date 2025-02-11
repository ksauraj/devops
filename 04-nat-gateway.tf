# We shold have an elastic IP for NAT Gateway, and idk why i am getting warning that vpc is depricated ( nor i care)
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub-subnet.id

  tags = {
    Name = "NAT Gateway on APP VPC for pvt subnets"
  }

  depends_on = [aws_internet_gateway.my-igw] # Ensure IGW is created first (got few handful of errors without this)
}