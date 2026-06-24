resource "aws_acm_certificate" "this" {
  domain_name               = "api.moni.my"
  validation_method         = "DNS"
  subject_alternative_names = ["admin.moni.my"]

  lifecycle {
    create_before_destroy = true
  }
}
