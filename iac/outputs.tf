output "web_server_url" {
  description = "URL pública del servidor web desplegado"
  value       = "http://${aws_instance.web_server.public_ip}"
}

output "cloudtrail_bucket_name" {
  description = "Bucket S3 donde se almacenan los logs de CloudTrail"
  value       = aws_s3_bucket.cloudtrail_logs.id
}

output "cloudwatch_log_group" {
  description = "Nombre del Log Group en CloudWatch"
  value       = aws_cloudwatch_log_group.web_logs.name
}