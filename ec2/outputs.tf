output "nat_instance_interface_id" {
  description = "NAT Instance 네트워크 인터페이스 ID (VPC 라우트 테이블 연결용)"
  value       = aws_instance.nat_instance.primary_network_interface_id
}

output "web1_id" {
  description = "서비스 EC2 인스턴스 ID (ALB 타겟 그룹 등록용)"
  value       = aws_instance.web1.id
}

output "web2_id" {
  description = "인프라 EC2 인스턴스 ID"
  value       = aws_instance.web2.id
}

output "web3_id" {
  description = "모니터링 EC2 인스턴스 ID (Grafana)"
  value       = aws_instance.web3.id
}