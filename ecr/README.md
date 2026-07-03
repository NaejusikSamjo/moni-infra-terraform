# ecr

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Inputs

No inputs.

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ec2_role_name"></a> [ec2\_role\_name](#output\_ec2\_role\_name) | EC2 IAM 역할 이름 (S3 정책 연결용) |
| <a name="output_instance_profile_name"></a> [instance\_profile\_name](#output\_instance\_profile\_name) | 서비스 EC2에 연결할 IAM Instance Profile 이름 (ECR pull 권한 포함) |
| <a name="output_repository_urls"></a> [repository\_urls](#output\_repository\_urls) | 서비스별 ECR 리포지토리 URL 맵 (GitHub Actions CD에서 이미지 푸시 대상) |
<!-- END_TF_DOCS -->
