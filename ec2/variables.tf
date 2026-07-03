variable "key_name" {
  description = "EC2 인스턴스에 적용할 키페어 이름"
}

variable "public_subnet_ids" {
  description = "Bastion Host, NAT Instance를 배치할 퍼블릭 서브넷 ID 목록"
}

variable "private_subnet_ids" {
  description = "서비스/인프라/모니터링 EC2를 배치할 프라이빗 서브넷 ID 목록"
}

variable "security_group_id" {
  description = "EC2 인스턴스에 적용할 보안 그룹 ID"
}

variable "instance_profile_name" {
  description = "서비스 EC2에 적용할 IAM Instance Profile 이름 (ECR pull 권한 포함)"
}
