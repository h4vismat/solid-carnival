
resource "aws_glue_job" "orders_process_to_raw" {
  name              = "orders_process_to_raw"
  role_arn          = aws_iam_role.glue_service_role.arn
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = "2"

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.lake.bucket}/scripts/orders_process_to_raw.py"
  }

  default_arguments = {
    "--DEST_BUCKET"               = "${aws_s3_bucket.lake.bucket}"
    "--LAYER"                     = "20_raw"
    "--DEST_FOLDER"               = "orders"
    "--enable-continuous-logging" = "true"
    "--log-group"                 = "/aws-glue/jobs/logs-v2"
    "--log-stream-prefix"         = "orders_process_to_raw"
    "--enable-metrics"            = ""
  }
}

resource "aws_glue_job" "refined_customer_revenue" {
  name              = "refined_customer_revenue"
  role_arn          = aws_iam_role.glue_service_role.arn
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = "2"

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.lake.bucket}/scripts/refined_customer_revenue.py"
  }

  default_arguments = {
    "--DEST_BUCKET"               = "${aws_s3_bucket.lake.bucket}"
    "--CATALOG_DATABASE"          = "raw"
    "--CATALOG_TABLE"             = "orders"
    "--LAYER"                     = "30_refined"
    "--DEST_FOLDER"               = "sales/customer_revenue"
    "--enable-continuous-logging" = "true"
    "--log-group"                 = "/aws-glue/jobs/logs-v2"
    "--log-stream-prefix"         = "refined_customer_revenue"
    "--enable-metrics"            = ""
  }
}

resource "aws_glue_job" "refined_product_sales" {
  name              = "refined_product_sales"
  role_arn          = aws_iam_role.glue_service_role.arn
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = "2"

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.lake.bucket}/scripts/refined_product_sales.py"
  }

  default_arguments = {
    "--DEST_BUCKET"               = "${aws_s3_bucket.lake.bucket}"
    "--CATALOG_DATABASE"          = "raw"
    "--CATALOG_TABLE"             = "orders"
    "--LAYER"                     = "30_refined"
    "--DEST_FOLDER"               = "sales/product_sales"
    "--enable-continuous-logging" = "true"
    "--log-group"                 = "/aws-glue/jobs/logs-v2"
    "--log-stream-prefix"         = "refined_product_sales"
    "--enable-metrics"            = ""
  }
}

resource "aws_glue_job" "refined_monthly_revenue" {
  name              = "refined_monthly_revenue"
  role_arn          = aws_iam_role.glue_service_role.arn
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = "2"

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.lake.bucket}/scripts/refined_monthly_revenue.py"
  }

  default_arguments = {
    "--DEST_BUCKET"               = "${aws_s3_bucket.lake.bucket}"
    "--CATALOG_DATABASE"          = "raw"
    "--CATALOG_TABLE"             = "orders"
    "--LAYER"                     = "30_refined"
    "--DEST_FOLDER"               = "sales/monthly_revenue"
    "--enable-continuous-logging" = "true"
    "--log-group"                 = "/aws-glue/jobs/logs-v2"
    "--log-stream-prefix"         = "refined_monthly_revenue"
    "--enable-metrics"            = ""
  }
}

resource "aws_glue_job" "trusted_customer_revenue" {
  name              = "trusted_customer_revenue"
  role_arn          = aws_iam_role.glue_service_role.arn
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = "2"

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.lake.bucket}/scripts/trusted_customer_revenue.py"
  }

  default_arguments = {
    "--DEST_BUCKET"               = "${aws_s3_bucket.lake.bucket}"
    "--CATALOG_DATABASE"          = "refined"
    "--CATALOG_TABLE"             = "customer_revenue"
    "--LAYER"                     = "40_trusted"
    "--DEST_FOLDER"               = "sales/customer_revenue"
    "--datalake-formats"          = "delta"
    "--enable-continuous-logging" = "true"
    "--log-group"                 = "/aws-glue/jobs/logs-v2"
    "--log-stream-prefix"         = "trusted_customer_revenue"
    "--enable-metrics"            = ""
    "--conf"                      = "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog --conf spark.delta.logStore.class=org.apache.spark.sql.delta.storage.S3SingleDriverLogStore"
  }
}

resource "aws_glue_job" "trusted_product_sales" {
  name              = "trusted_product_sales"
  role_arn          = aws_iam_role.glue_service_role.arn
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = "2"

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.lake.bucket}/scripts/trusted_product_sales.py"
  }

  default_arguments = {
    "--DEST_BUCKET"               = "${aws_s3_bucket.lake.bucket}"
    "--CATALOG_DATABASE"          = "refined"
    "--CATALOG_TABLE"             = "product_sales"
    "--LAYER"                     = "40_trusted"
    "--DEST_FOLDER"               = "sales/product_sales"
    "--datalake-formats"          = "delta"
    "--enable-continuous-logging" = "true"
    "--log-group"                 = "/aws-glue/jobs/logs-v2"
    "--log-stream-prefix"         = "trusted_product_sales"
    "--enable-metrics"            = ""
    "--conf"                      = "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog --conf spark.delta.logStore.class=org.apache.spark.sql.delta.storage.S3SingleDriverLogStore"
  }
}

resource "aws_glue_job" "trusted_monthly_revenue" {
  name              = "trusted_monthly_revenue"
  role_arn          = aws_iam_role.glue_service_role.arn
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = "2"

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.lake.bucket}/scripts/trusted_monthly_revenue.py"
  }

  default_arguments = {
    "--DEST_BUCKET"               = "${aws_s3_bucket.lake.bucket}"
    "--CATALOG_DATABASE"          = "refined"
    "--CATALOG_TABLE"             = "monthly_revenue"
    "--LAYER"                     = "40_trusted"
    "--DEST_FOLDER"               = "sales/monthly_revenue"
    "--datalake-formats"          = "delta"
    "--enable-continuous-logging" = "true"
    "--log-group"                 = "/aws-glue/jobs/logs-v2"
    "--log-stream-prefix"         = "trusted_monthly_revenue"
    "--enable-metrics"            = ""
    "--conf"                      = "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog --conf spark.delta.logStore.class=org.apache.spark.sql.delta.storage.S3SingleDriverLogStore"
  }
}
