variable "aws_region" {
  description = "Región de despliegue en AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefijo para identificar los recursos del proyecto"
  type        = string
  default     = "inacap-web-devops"
}

variable "alert_email" {
  description = "Correo electrónico para recibir notificaciones de CloudWatch SNS"
  type        = string
  default     = "paula.cofre@inacapmail.cl"
}