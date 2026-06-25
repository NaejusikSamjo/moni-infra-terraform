data "aws_route53_zone" "api" {
  name         = "api.moni.my"
  private_zone = false
}

data "aws_route53_zone" "admin" {
  name         = "admin.moni.my"
  private_zone = false
}

resource "aws_route53_record" "acm_validation_api" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
    if dvo.domain_name == "api.moni.my"
  }

  zone_id = data.aws_route53_zone.api.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60

  allow_overwrite = true
}

resource "aws_route53_record" "acm_validation_admin" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
    if dvo.domain_name == "admin.moni.my"
  }

  zone_id = data.aws_route53_zone.admin.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60

  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = var.certificate_arn
  validation_record_fqdns = concat(
    [for r in aws_route53_record.acm_validation_api : r.fqdn],
    [for r in aws_route53_record.acm_validation_admin : r.fqdn]
  )
}