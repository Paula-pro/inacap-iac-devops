# --- ÍTEM 1: Recopilación de registros (CloudWatch Log Group) ---
resource "aws_cloudwatch_log_group" "web_logs" {
  name              = "/aws/ec2/${var.project_name}"
  retention_in_days = 14
}

# --- ÍTEM 2: Alarma y notificación temprana (CloudWatch Alarm + SNS) ---
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alerta cuando el uso de CPU supera el 70% durante 4 minutos"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = aws_instance.web_server.id
  }
}

# --- ÍTEM 3: Trazabilidad de acciones en la cuenta (AWS CloudTrail) ---
resource "aws_cloudtrail" "account_trail" {
  name                          = "${var.project_name}-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  include_global_service_events = true
  is_multi_region_trail         = false
  enable_log_file_validation    = true

  depends_on = [aws_s3_bucket_policy.cloudtrail_policy]
}