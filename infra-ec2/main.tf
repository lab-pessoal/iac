terraform {
  required_version = ">= 1.5.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC default (mínimo)
data "aws_vpc" "default" {
  default = true
}

# Subnet default
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Ubuntu 22.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group mínimo
resource "aws_security_group" "ec2" {
  name   = "${var.app_name}-${var.env}-sg"
  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.allow_ssh ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.ssh_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-${var.env}-sg"
    App         = var.app_name
    Environment = var.env
    ManagedBy   = "terraform"
  }
}

# EC2 mínima
resource "aws_instance" "this" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.ec2.id]

  associate_public_ip_address = var.associate_public_ip

  tags = {
    Name        = "${var.app_name}-${var.env}-ec2"
    App         = var.app_name
    Environment = var.env
    ManagedBy   = "terraform"
    Repo        = var.app_name
  }
}
