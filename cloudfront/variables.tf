variable "bucket_name" {
  description = "S3 bucket name"
}

variable "bucket_regional_domain_name" {
  description = "S3 bucket regional domain name"
}

variable "certificate_arn" {
  description = "ACM certificate ARN (us-east-1) for cdn.moni.my"
}

variable "domain_name" {
  description = "Custom domain for CloudFront"
  default     = "cdn.moni.my"
}
