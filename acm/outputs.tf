output "certificate_arn" {
  description = "ACM 인증서 ARN (api/admin/grafana.moni.my SAN)"
  value       = aws_acm_certificate.this.arn
}

output "domain_validation_options" {
  description = "ACM DNS 검증에 필요한 레코드 정보"
  value       = aws_acm_certificate.this.domain_validation_options
}
