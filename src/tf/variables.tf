variable "access_key" {
  description = "IAM user access key"
  type        = string
}

variable "secret_key" {
  description = "IAM user secret key"
  type        = string
}

variable "s3_lake_bucket_name" {
  description = "S3 bucket name."
  type        = string
}

variable "glue_workflow_name" {
  description = "Glue workflow name."
  type        = string
  default     = "sales-workflow-glue"
}

variable "glue_job_names" {
  type = list(string)
  default = [
    "orders_process_to_raw",
    "refined_customer_revenue",
    "refined_monthly_revenue",
    "refined_product_sales",
    "trusted_monthly_revenue",
    "trusted_product_sales",
    "trusted_customer_revenue"
  ]
}

variable "alarm_email" {
  description = "E-mail to receive Cloudwatch alarms."
  type        = string
}
