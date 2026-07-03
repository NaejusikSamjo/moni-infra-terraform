variable "vpc_id" {
  description = "서브넷을 생성할 VPC ID"
}

variable "route_table_id" {
  description = "퍼블릭 서브넷에 연결할 라우트 테이블 ID"
}

variable "route_table_id1" {
  description = "프라이빗 서브넷에 연결할 라우트 테이블 ID (NAT Instance 경유)"
}
