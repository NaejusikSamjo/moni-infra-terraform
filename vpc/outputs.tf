output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "route_table_id" {
  description = "퍼블릭 서브넷 라우트 테이블 ID"
  value       = aws_route_table.main.id
}

output "route_table_id1" {
  description = "프라이빗 서브넷 라우트 테이블 ID (NAT Instance 경유)"
  value       = aws_route_table.main1.id
}