output "dns_name" {
  description = "ALB DNS 이름 (Route 53 alias 대상)"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "ALB 호스팅 영역 ID (Route 53 alias 설정용)"
  value       = aws_lb.this.zone_id
}
