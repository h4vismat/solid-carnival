resource "aws_glue_crawler" "sales_raw" {
  database_name = aws_glue_catalog_database.raw.name
  name          = "sales_raw"
  role          = aws_iam_role.glue_service_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.lake.bucket}/20_raw/orders"
  }
}

resource "aws_glue_crawler" "sales_refined" {
  database_name = aws_glue_catalog_database.refined.name
  name          = "sales_refined"
  role          = aws_iam_role.glue_service_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.lake.bucket}/30_refined/sales/customer_revenue"
  }

  s3_target {
    path = "s3://${aws_s3_bucket.lake.bucket}/30_refined/sales/product_sales"
  }

  s3_target {
    path = "s3://${aws_s3_bucket.lake.bucket}/30_refined/sales/monthly_revenue"
  }
}

resource "aws_glue_crawler" "sales_trusted" {
  database_name = aws_glue_catalog_database.trusted.name
  name          = "sales_trusted"
  role          = aws_iam_role.glue_service_role.arn

  delta_target {
    delta_tables   = ["s3://${aws_s3_bucket.lake.bucket}/40_trusted/sales/product_sales/", "s3://${aws_s3_bucket.lake.bucket}/40_trusted/sales/customer_revenue/", "s3://${aws_s3_bucket.lake.bucket}/40_trusted/sales/monthly_revenue/"]
    write_manifest = true
  }
}
