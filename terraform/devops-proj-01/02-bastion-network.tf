resource "aws_vpc" "bastion-vpc" {
    cidr_block = "192.168.0.0/16"
    tags = {
        Name = "bastion_vpc"
    }
}

resource "aws_subnet" "bastion-subnet" {
    vpc_id     = aws_vpc.bastion-vpc.id
    cidr_block = "192.168.0.0/24"

    tags = {
        Name = "bastion-subnet"
    } 
}


resource "aws_internet_gateway" "bastion-igw" {
    vpc_id = aws_vpc.bastion-vpc.id
    tags = {
      Name = "bastion-igw"
    }
}

resource "aws_route_table" "bastion-rt" {
    vpc_id = aws_vpc.bastion-vpc.id
    route {
        gateway_id = aws_internet_gateway.bastion-igw.id
        cidr_block = "0.0.0.0/0"
    }
    route {
        transit_gateway_id = aws_ec2_transit_gateway.tgw.id
        cidr_block = "172.32.0.0/16"
    }
    tags = {
        Name = "bastion-route-table"
    }
}

resource "aws_route_table_association" "bastion-rt-ass" {
    subnet_id = aws_subnet.bastion-subnet.id
    route_table_id = aws_route_table.bastion-rt.id
}


