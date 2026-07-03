output "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 목록 (Bastion Host, NAT Instance, ALB 배치)"
  value       = [aws_subnet.public1.id, aws_subnet.public2.id]
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 목록 (서비스/인프라/모니터링 EC2 배치)"
  value       = [aws_subnet.private1.id, aws_subnet.private2.id]
}