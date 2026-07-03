variable "certificate_arn" {
  description = "ACM 인증서 ARN (api/admin/grafana.moni.my SAN)"
}

variable "domain_validation_options" {
  description = "ACM DNS 검증에 필요한 레코드 정보"
  type = set(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}
