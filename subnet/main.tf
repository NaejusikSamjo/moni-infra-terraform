resource "aws_subnet" "public1" {

  vpc_id = var.vpc_id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public2" {

  vpc_id = var.vpc_id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private1" {

  vpc_id = var.vpc_id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private2" {

  vpc_id = var.vpc_id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = var.route_table_id
}

resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = var.route_table_id
}

resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = var.route_table_id1
}

resource "aws_route_table_association" "private_2" {
  subnet_id = aws_subnet.private2.id
  route_table_id = var.route_table_id1
}