resource "aws_glue_workflow" "workflow" {
  name = var.glue_workflow_name
}

resource "aws_glue_trigger" "workflow_schedule_trigger" {
  name          = "daily_workflow_trigger"
  type          = "SCHEDULED"
  workflow_name = aws_glue_workflow.workflow.name
  schedule      = "cron(0 7 * * ? *)"

  actions {
    job_name = aws_glue_job.orders_process_to_raw.name
  }
}

resource "aws_glue_trigger" "process_to_raw_completion_trigger" {
  name          = "process_to_raw_completion_trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.workflow.name

  predicate {
    conditions {
      job_name = aws_glue_job.orders_process_to_raw.name
      state    = "SUCCEEDED"
    }
  }

  actions {
    crawler_name = aws_glue_crawler.sales_raw.name
  }
}

resource "aws_glue_trigger" "raw_crawler_completion_trigger" {
  name          = "raw_crawler_completion_trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.workflow.name

  predicate {
    conditions {
      crawler_name = aws_glue_crawler.sales_raw.name
      crawl_state  = "SUCCEEDED"
    }
  }

  actions {
    job_name = aws_glue_job.refined_customer_revenue.name
  }

  actions {
    job_name = aws_glue_job.refined_product_sales.name
  }

  actions {
    job_name = aws_glue_job.refined_monthly_revenue.name
  }
}

resource "aws_glue_trigger" "refined_jobs_completion_trigger" {
  name          = "refined_jobs_completion_trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.workflow.name

  predicate {
    conditions {
      job_name = aws_glue_job.refined_customer_revenue.name
      state    = "SUCCEEDED"
    }

    conditions {
      job_name = aws_glue_job.refined_product_sales.name
      state    = "SUCCEEDED"
    }

    conditions {
      job_name = aws_glue_job.refined_monthly_revenue.name
      state    = "SUCCEEDED"
    }
  }

  actions {
    crawler_name = aws_glue_crawler.sales_refined.name
  }
}

resource "aws_glue_trigger" "refined_crawler_completion_trigger" {
  name          = "refined_crawler_completion_trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.workflow.name

  predicate {
    conditions {
      crawler_name = aws_glue_crawler.sales_refined.name
      crawl_state  = "SUCCEEDED"
    }
  }

  actions {
    job_name = aws_glue_job.trusted_customer_revenue.name
  }

  actions {
    job_name = aws_glue_job.trusted_product_sales.name
  }

  actions {
    job_name = aws_glue_job.trusted_monthly_revenue.name
  }
}

resource "aws_glue_trigger" "trusted_jobs_completion_trigger" {
  name          = "trusted_jobs_completion_trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.workflow.name

  predicate {
    conditions {
      job_name = aws_glue_job.trusted_customer_revenue.name
      state    = "SUCCEEDED"
    }

    conditions {
      job_name = aws_glue_job.trusted_product_sales.name
      state    = "SUCCEEDED"
    }

    conditions {
      job_name = aws_glue_job.trusted_monthly_revenue.name
      state    = "SUCCEEDED"
    }
  }

  actions {
    crawler_name = aws_glue_crawler.sales_trusted.name
  }
}
