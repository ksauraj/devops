resource "aws_vpc" "app-vpc" {
    cidr_block = "172.32.0.0/16"
    tags = {
        Name = "app_vpc"
    }
}

resource "aws_subnet" "pub-subnet" {
    vpc_id     = aws_vpc.app-vpc.id
    cidr_block = "172.32.0.0/24"
    availability_zone = "us-east-1c"

    tags = {
        Name = "nat-subnet"
    } 
}

resource "aws_subnet" "nlb-subnet" {
    vpc_id     = aws_vpc.app-vpc.id
    cidr_block = "172.32.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "nlb-subnet"
    } 
}

resource "aws_subnet" "pvt-1-subnet" {
    vpc_id     = aws_vpc.app-vpc.id
    cidr_block = "172.32.2.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "pvt-1-subnet"
    } 
}

resource "aws_subnet" "pvt-2-subnet" {
    vpc_id     = aws_vpc.app-vpc.id
    cidr_block = "172.32.3.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "pvt-2-subnet"
    } 
}



resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.app-vpc.id
    tags = {
      Name = "app-igw"
    }
}

# same route for both the public subnets (NLB and NAT)
resource "aws_route_table" "pub-rt" {
    vpc_id = aws_vpc.app-vpc.id
    route {
        gateway_id = aws_internet_gateway.my-igw.id
        cidr_block = "0.0.0.0/0"
    }
    route {
        transit_gateway_id = aws_ec2_transit_gateway.tgw.id
        cidr_block = "192.168.0.0/16"
    }
    tags = {
        Name = "pub-route-table"
    }
}

resource "aws_route_table" "pvt-rt" {
    vpc_id = aws_vpc.app-vpc.id
    route {
        transit_gateway_id = aws_ec2_transit_gateway.tgw.id
        cidr_block = "192.168.0.0/16"
    }
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id
    }
    tags = {
        Name = "pvt-route-table"
    }
}

resource "aws_route_table_association" "nlb-rt-ass" {
    subnet_id = aws_subnet.nlb-subnet.id
    route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "pub-rt-ass" {
    subnet_id = aws_subnet.pub-subnet.id
    route_table_id = aws_route_table.pub-rt.id
}


resource "aws_route_table_association" "pvt-1-rt-ass" {
    subnet_id = aws_subnet.pvt-1-subnet.id
    route_table_id = aws_route_table.pvt-rt.id
}

resource "aws_route_table_association" "pvt-2-rt-ass" {
    subnet_id = aws_subnet.pvt-2-subnet.id
    route_table_id = aws_route_table.pvt-rt.id
}