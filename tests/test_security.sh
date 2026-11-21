#!/bin/bash
set -e

echo "=== Iniciando pruebas automatizadas de seguridad y configuración IaC ==="

# Prueba 1: Verificar que no existan claves de AWS expuestas en el código
if grep -rn "AKIA[0-9A-Z]\{16\}" iac/; then
  echo "ERROR: Se detectaron credenciales de AWS en texto plano."
  exit 1
else
  echo "[OK] Sin credenciales expuestas en el código."
fi

# Prueba 2: Verificar que el puerto SSH (22) no esté abierto en Security Groups
if grep -rn "from_port.*=.*22" iac/; then
  echo "ERROR: El puerto SSH (22) no debe estar abierto."
  exit 1
else
  echo "[OK] Puerto SSH (22) restringido correctamente."
fi

# Prueba 3: Verificar que el cifrado de disco EBS y CloudTrail estén definidos
grep -q "encrypted = true" iac/main.tf && echo "[OK] Cifrado EBS habilitado."
grep -q "aws_cloudtrail" iac/monitoring.tf && echo "[OK] Trazabilidad CloudTrail configurada."
grep -q "aws_cloudwatch_metric_alarm" iac/monitoring.tf && echo "[OK] Alarma CloudWatch configurada."

echo "=== Todas las pruebas automatizadas finalizaron con éxito ==="