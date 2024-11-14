variable "scripts_to_upload" {
  type = list(string)
  default = [
    "orders_process_to_raw.py",
    "refined_customer_revenue.py",
    "refined_monthly_revenue.py",
    "refined_product_sales.py",
    "trusted_monthly_revenue.py",
    "trusted_product_sales.py",
    "trusted_customer_revenue.py"
  ]
}


resource "aws_s3_bucket" "lake" {
  bucket        = var.s3_lake_bucket_name
  force_destroy = true

  tags = {
    Name = "s3 data lake bucket"
  }
}

resource "aws_s3_object" "sales_data" {
  bucket = aws_s3_bucket.lake.bucket
  key    = "10_landing/orders/sales_data.csv"
  source = "../files/sales_data.csv"

  etag = filemd5("../files/sales_data.csv")
  depends_on = [
    aws_s3_bucket.lake
  ]
}

resource "aws_s3_object" "script" {
  for_each = toset(var.scripts_to_upload)
  bucket   = aws_s3_bucket.lake.bucket

  key    = "scripts/${each.key}"
  source = "../scripts/${each.key}"

  etag = filemd5("../scripts/${each.key}")
  depends_on = [
    aws_s3_bucket.lake
  ]
}
