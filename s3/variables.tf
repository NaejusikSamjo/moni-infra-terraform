variable "bucket_name" {
  description = "생성할 S3 버킷 이름"
}

variable "acl" {
  description = "S3 버킷 ACL 설정 (private 권장)"
}

variable "ec2_role_name" {
  description = "S3 접근 정책을 연결할 EC2 IAM 역할 이름"
}