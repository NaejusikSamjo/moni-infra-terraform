# ec2

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
| <a name="input_instance_profile_name"></a> [instance\_profile\_name](#input\_instance\_profile\_name) | 서비스 EC2에 적용할 IAM Instance Profile 이름 (ECR pull 권한 포함) | `any` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | EC2 인스턴스에 적용할 키페어 이름 | `any` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | 서비스/인프라/모니터링 EC2를 배치할 프라이빗 서브넷 ID 목록 | `any` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | Bastion Host, NAT Instance를 배치할 퍼블릭 서브넷 ID 목록 | `any` | n/a | yes |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | EC2 인스턴스에 적용할 보안 그룹 ID | `any` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_nat_instance_interface_id"></a> [nat\_instance\_interface\_id](#output\_nat\_instance\_interface\_id) | NAT Instance 네트워크 인터페이스 ID (VPC 라우트 테이블 연결용) |
| <a name="output_web1_id"></a> [web1\_id](#output\_web1\_id) | 서비스 EC2 인스턴스 ID (ALB 타겟 그룹 등록용) |
| <a name="output_web2_id"></a> [web2\_id](#output\_web2\_id) | 인프라 EC2 인스턴스 ID |
| <a name="output_web3_id"></a> [web3\_id](#output\_web3\_id) | 모니터링 EC2 인스턴스 ID (Grafana) |
<!-- END_TF_DOCS -->
