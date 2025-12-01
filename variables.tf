variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "strapi_admin_email" {
  description = "Strapi admin email"
  type        = string
  default     = "admin@example.com"
}

variable "strapi_admin_password" {
  description = "Strapi admin password"
  type        = string
  default     = "Admin123!"
  sensitive   = true
}
