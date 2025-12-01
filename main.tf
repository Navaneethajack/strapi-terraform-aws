terraform {
  required_version = ">= 1.0"
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

# Security Group for Strapi
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-security-group"
  description = "Security group for Strapi CMS"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "strapi-sg"
  }
}

# EC2 Instance for Strapi
resource "aws_instance" "strapi_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.strapi_key.key_name
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  user_data              = filebase64("${path.module}/scripts/user-data.sh")

  tags = {
    Name = "strapi-cms-server"
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
}

# Key pair for SSH access
resource "aws_key_pair" "strapi_key" {
  key_name   = "strapi-key"
  public_key = file("~/.ssh/id_rsa.pub") # Replace with your public key path
}

# Get latest Ubuntu AMI
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

# Elastic IP for static public IP
resource "aws_eip" "strapi_eip" {
  instance = aws_instance.strapi_server.id
  tags = {
    Name = "strapi-elastic-ip"
  }
}
