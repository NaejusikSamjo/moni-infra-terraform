variable "vpc_id" {
  description = "ALB를 배치할 VPC ID"
}

variable "subnet_ids" {
  description = "ALB를 배치할 퍼블릭 서브넷 ID 목록"
}

variable "security_group_ids" {
  description = "ALB에 적용할 보안 그룹 ID 목록"
}

variable "target_instance_id" {
  description = "서비스 EC2 인스턴스 ID (api-gateway :8080)"
}

variable "infra_instance_id" {
  description = "인프라 EC2 인스턴스 ID"
}

variable "monitor_instance_id" {
  description = "모니터링 EC2 인스턴스 ID (Grafana :3000)"
}

variable "certificate_arn" {
  description = "HTTPS 리스너에 적용할 ACM 인증서 ARN"
}
