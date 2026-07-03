output "repository_urls" {
  description = "서비스별 ECR 리포지토리 URL 맵 (GitHub Actions CD에서 이미지 푸시 대상)"
  value       = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}

output "instance_profile_name" {
  description = "서비스 EC2에 연결할 IAM Instance Profile 이름 (ECR pull 권한 포함)"
  value       = aws_iam_instance_profile.ec2_ecr_profile.name
}

output "ec2_role_name" {
  description = "EC2 IAM 역할 이름 (S3 정책 연결용)"
  value       = aws_iam_role.ec2_ecr_role.name
}
