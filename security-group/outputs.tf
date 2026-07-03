output "security_group_id" {
  description = "보안 그룹 ID (EC2, ALB에 공통 적용)"
  value       = aws_security_group.allow_ssh.id
}