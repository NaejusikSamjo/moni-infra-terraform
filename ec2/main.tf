resource "aws_instance" "bastion_host" {
  ami                    = "ami-040c33c6a51fd5d96"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_id]
  availability_zone      = "ap-northeast-2a"
  key_name               = var.key_name

  tags = {
    Name = "bastion_host"
  }
}

resource "aws_instance" "nat_instance" {
  ami                    = "ami-0c2d3e23e757b5d84"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_ids[1]
  vpc_security_group_ids = [var.security_group_id]
  availability_zone      = "ap-northeast-2c"
  key_name               = var.key_name
  source_dest_check      = false

  tags = {
    Name = "nat_instance"
  }
}

resource "aws_instance" "web1" {
  ami                    = "ami-0b69aee074c0d5812"
  instance_type          = "t4g.large"
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_id]
  availability_zone      = "ap-northeast-2a"
  key_name               = var.key_name
  iam_instance_profile   = var.instance_profile_name

  tags = {
    Name = "service"
  }
}

resource "aws_instance" "web2" {
  ami                    = "ami-0b69aee074c0d5812"
  instance_type          = "r8g.medium"
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_id]
  availability_zone      = "ap-northeast-2a"
  key_name               = var.key_name

  tags = {
    Name = "infra"
  }
}

resource "aws_instance" "web3" {
  ami                    = "ami-0b69aee074c0d5812"
  instance_type          = "t4g.small"
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_id]
  availability_zone      = "ap-northeast-2a"
  key_name               = var.key_name

  tags = {
    Name = "monitor"
  }
}