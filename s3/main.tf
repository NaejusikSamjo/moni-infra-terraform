resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_iam_role_policy" "s3_profile_access" {
  name = "moni-s3-profile-access"
  role = var.ec2_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}/profiles/*",
          "arn:aws:s3:::${var.bucket_name}/logs/*"
        ]
      }
    ]
  })
}