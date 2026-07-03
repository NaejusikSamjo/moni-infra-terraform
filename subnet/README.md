# subnet

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
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | 퍼블릭 서브넷에 연결할 라우트 테이블 ID | `any` | n/a | yes |
| <a name="input_route_table_id1"></a> [route\_table\_id1](#input\_route\_table\_id1) | 프라이빗 서브넷에 연결할 라우트 테이블 ID (NAT Instance 경유) | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | 서브넷을 생성할 VPC ID | `any` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | 프라이빗 서브넷 ID 목록 (서비스/인프라/모니터링 EC2 배치) |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | 퍼블릭 서브넷 ID 목록 (Bastion Host, NAT Instance, ALB 배치) |
<!-- END_TF_DOCS -->
