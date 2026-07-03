output "certificate_arn" {
  description = "DNS 검증 완료된 ACM 인증서 ARN (ALB HTTPS 리스너 연결용)"
  value       = aws_acm_certificate_validation.this.certificate_arn
}