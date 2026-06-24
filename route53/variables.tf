variable "certificate_arn" {}
variable "domain_validation_options" {
  type = set(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}
variable "alb_dns_name" {}
variable "alb_zone_id" {}
