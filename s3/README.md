# s3

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
| <a name="input_acl"></a> [acl](#input\_acl) | S3 버킷 ACL 설정 (private 권장) | `any` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | 생성할 S3 버킷 이름 | `any` | n/a | yes |
| <a name="input_ec2_role_name"></a> [ec2\_role\_name](#input\_ec2\_role\_name) | S3 접근 정책을 연결할 EC2 IAM 역할 이름 | `any` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | S3 버킷 ARN |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | S3 버킷 이름 |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | S3 버킷 리전 도메인 이름 (CloudFront Origin 설정용) |
<!-- END_TF_DOCS -->
