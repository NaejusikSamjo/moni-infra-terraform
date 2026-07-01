provider "aws" {
  region = "ap-northeast-2"
}

module "key_pair" {
  source = "./key-pair"
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

module "ecr" {
  source = "./ecr"
}

module "ec2" {
  source                = "./ec2"
  security_group_id     = module.security_group.security_group_id
  public_subnet_ids     = module.subnet.public_subnet_ids
  private_subnet_ids    = module.subnet.private_subnet_ids
  key_name              = module.key_pair.key_name
  instance_profile_name = module.ecr.instance_profile_name
}

module "s3" {
  source        = "./s3"
  bucket_name   = "log-bucket-samzo-moni"
  acl           = "private"
  ec2_role_name = module.ecr.ec2_role_name
}

module "acm" {
  source = "./acm"
}

module "route53" {
  source                    = "./route53"
  certificate_arn           = module.acm.certificate_arn
  domain_validation_options = module.acm.domain_validation_options
}

module "alb" {
  source             = "./alb"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.subnet.public_subnet_ids
  security_group_ids = [module.security_group.security_group_id]
  target_instance_id  = module.ec2.web1_id
  infra_instance_id   = module.ec2.web2_id
  monitor_instance_id = module.ec2.web3_id
  certificate_arn    = module.route53.certificate_arn
}

data "aws_route53_zone" "api" {
  name         = "api.moni.my"
  private_zone = false
}

data "aws_route53_zone" "admin" {
  name         = "admin.moni.my"
  private_zone = false
}

data "aws_route53_zone" "grafana" {
  zone_id = "Z0650037E5KL9WC3NDZ7"
}

resource "aws_route53_record" "api" {
  zone_id         = data.aws_route53_zone.api.zone_id
  name            = "api.moni.my"
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "admin" {
  zone_id         = data.aws_route53_zone.admin.zone_id
  name            = "admin.moni.my"
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "grafana" {
  zone_id         = data.aws_route53_zone.grafana.zone_id
  name            = "grafana.moni.my"
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}