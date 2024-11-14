resource "aws_sns_topic" "glue_job_alarm_topic" {
  name = "job-failure-alarm-topic"
}

resource "aws_sns_topic_subscription" "glue_job_alarm_email" {
  topic_arn = aws_sns_topic.glue_job_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

resource "aws_cloudwatch_metric_alarm" "glue_job_failure_alarm" {
  for_each            = toset(var.glue_job_names)
  alarm_name          = "GlueJobFailureAlarm-${each.key}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "Glue"
  period              = "300" # 5 mins
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alerta caso o job ${each.key} falhar."
  actions_enabled     = true

  alarm_actions = [aws_sns_topic.glue_job_alarm_topic.arn] # trigger SNS
  dimensions = {
    JobName = each.key
  }
}
