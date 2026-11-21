# Implementación de Infraestructura como Código (IaC), Monitoreo y Seguridad en AWS

Proyecto desarrollado para la asignatura de **DevOps** en **INACAP** (Ingeniería en Informática) por **Paula Cofré**.

## Descripción
Despliegue automatizado de un servidor web Apache en **AWS (`us-east-1`)** utilizando **Terraform (`v1.9.5`)** y un pipeline de Integración Continua en **GitHub Actions**. La arquitectura aprovisiona **15 recursos** integrando observabilidad, trazabilidad, pruebas automatizadas de seguridad y control de accesos bajo el principio de mínimo privilegio.

## Arquitectura y Servicios
- **Cómputo:** Instancia EC2 (Amazon Linux 2023 + Apache HTTP) con IMDSv2 obligatorio y volumen EBS cifrado.
- **Monitoreo y Alertas:** Amazon CloudWatch Logs (`/aws/ec2/inacap-web-devops`, retención de 14 días) y Alarma de CPU (> 70%) conectada a **Amazon SNS**.
- **Auditoría y Trazabilidad:** AWS CloudTrail (`inacap-web-devops-trail`) con almacenamiento en bucket S3 cifrado y bloqueo de acceso público.
- **Seguridad:** Rol IAM de mínimo privilegio (`inacap-web-devops-ec2-role`) y Security Group (`inacap-web-devops-sg`) restringido únicamente al puerto HTTP (80), sin acceso SSH (22).
- **CI/CD:** GitHub Actions ejecuta `terraform fmt`, `terraform validate`, `test_security.sh` y `terraform plan` utilizando **GitHub Secrets** (`AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY`).

## Estructura del Repositorio
- `iac/`: Archivos de configuración de Terraform (`main.tf`, `variables.tf`, `outputs.tf`).
- `tests/`: Script automatizado de validación de seguridad (`test_security.sh`).
- `.github/workflows/`: Pipeline de CI/CD en GitHub Actions.

## Ejecución
```bash
cd iac
terraform init
terraform plan
terraform apply -auto-approve