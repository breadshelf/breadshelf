resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "private_1" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-2a"

  tags = {
    Name = "Private"
  }
}

resource "aws_subnet" "private_2" {
 cidr_block = "10.0.2.0/24"
 vpc_id = aws_vpc.main.id
 availability_zone = "us-east-2b"

 tags = {
    Name = "Private"
 }
}

resource "aws_subnet" "public" {
  cidr_block              = "10.0.101.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
