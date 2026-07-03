# route53

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ACM 인증서 ARN (api/admin/grafana.moni.my SAN) | `any` | n/a | yes |
| <a name="input_domain_validation_options"></a> [domain\_validation\_options](#input\_domain\_validation\_options) | ACM DNS 검증에 필요한 레코드 정보 | <pre>set(object({<br/>    domain_name           = string<br/>    resource_record_name  = string<br/>    resource_record_type  = string<br/>    resource_record_value = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | DNS 검증 완료된 ACM 인증서 ARN (ALB HTTPS 리스너 연결용) |
<!-- END_TF_DOCS -->
