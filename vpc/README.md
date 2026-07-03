# vpc

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
| <a name="input_nat_instance_network_interface_id"></a> [nat\_instance\_network\_interface\_id](#input\_nat\_instance\_network\_interface\_id) | NAT Instance의 네트워크 인터페이스 ID (프라이빗 서브넷 인터넷 라우팅용) | `any` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | 퍼블릭 서브넷 라우트 테이블 ID |
| <a name="output_route_table_id1"></a> [route\_table\_id1](#output\_route\_table\_id1) | 프라이빗 서브넷 라우트 테이블 ID (NAT Instance 경유) |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
<!-- END_TF_DOCS -->
