terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  # Control de seguridad adicional: cifrado del disco EBS y metadatos IMDSv2
  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Sistema Cloud Gestionado con IaC - INACAP</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "${var.project_name}-ec2"
    Environment = "DevOps-Lab"
    ManagedBy   = "Terraform"
  }
}