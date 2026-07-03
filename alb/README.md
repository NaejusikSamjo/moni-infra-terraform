# alb

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
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | HTTPS 리스너에 적용할 ACM 인증서 ARN | `any` | n/a | yes |
| <a name="input_infra_instance_id"></a> [infra\_instance\_id](#input\_infra\_instance\_id) | 인프라 EC2 인스턴스 ID | `any` | n/a | yes |
| <a name="input_monitor_instance_id"></a> [monitor\_instance\_id](#input\_monitor\_instance\_id) | 모니터링 EC2 인스턴스 ID (Grafana :3000) | `any` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | ALB에 적용할 보안 그룹 ID 목록 | `any` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | ALB를 배치할 퍼블릭 서브넷 ID 목록 | `any` | n/a | yes |
| <a name="input_target_instance_id"></a> [target\_instance\_id](#input\_target\_instance\_id) | 서비스 EC2 인스턴스 ID (api-gateway :8080) | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ALB를 배치할 VPC ID | `any` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | ALB DNS 이름 (Route 53 alias 대상) |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | ALB 호스팅 영역 ID (Route 53 alias 설정용) |
<!-- END_TF_DOCS -->
