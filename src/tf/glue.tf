resource "aws_iam_role" "glue_service_role" {

  name = "glue-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "glue-service-role"
  }
}

resource "aws_iam_policy" "glue_service_policy" {
  name = "glue-service-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.lake.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.lake.bucket}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "glue:*"
        ]
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_policy" "glue_cloudwatch_policy" {
  name = "glue-cloudwatch-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_cloudwatch_policy_attach" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.glue_cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_service_policy_attach" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.glue_service_policy.arn
}

output "glue_service_role_arn" {
  value = aws_iam_role.glue_service_role.arn
}

resource "aws_glue_catalog_database" "raw" {
  name = "raw"
}

resource "aws_glue_catalog_database" "refined" {
  name = "refined"

}
resource "aws_glue_catalog_database" "trusted" {
  name = "trusted"
}
