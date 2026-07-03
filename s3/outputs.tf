output "bucket_arn" {
  description = "S3 버킷 ARN"
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "S3 버킷 이름"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_regional_domain_name" {
  description = "S3 버킷 리전 도메인 이름 (CloudFront Origin 설정용)"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}