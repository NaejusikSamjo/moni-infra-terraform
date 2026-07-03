output "cloudfront_domain" {
  description = "CloudFront 배포 도메인 이름 (Route 53 alias 대상)"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront 배포 ID"
  value       = aws_cloudfront_distribution.this.id
}
