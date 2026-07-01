output "repository_urls" {
  value = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_ecr_profile.name
}

output "ec2_role_name" {
  value = aws_iam_role.ec2_ecr_role.name
}
