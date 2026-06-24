provider "aws" {
  region = "ap-northeast-2"
}

variable "key_name" {
  description = "EC2 Key Pair 이름 (aws_key_pair import 후 사용)"
  type        = string
}

module "vpc" {
  source                            = "./vpc"
  nat_instance_network_interface_id = module.ec2.nat_instance_interface_id
}

module "subnet" {
  source          = "./subnet"
  vpc_id          = module.vpc.vpc_id
  route_table_id  = module.vpc.route_table_id
  route_table_id1 = module.vpc.route_table_id1
}

module "security_group" {
  source = "./security-group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source             = "./ec2"
  security_group_id  = module.security_group.security_group_id
  public_subnet_ids  = module.subnet.public_subnet_ids
  private_subnet_ids = module.subnet.private_subnet_ids
  key_name           = var.key_name
}

module "s3" {
  source      = "./s3"
  bucket_name = "log-bucket-samzo-moni"
  acl         = "private"
}

module "acm" {
  source = "./acm"
}

module "alb" {
  source             = "./alb"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.subnet.public_subnet_ids
  security_group_ids = [module.security_group.security_group_id]
  target_instance_id = module.ec2.web1_id
  certificate_arn    = module.acm.certificate_arn
}

module "route53" {
  source                    = "./route53"
  certificate_arn           = module.acm.certificate_arn
  domain_validation_options = module.acm.domain_validation_options
  alb_dns_name              = module.alb.dns_name
  alb_zone_id               = module.alb.zone_id
}
