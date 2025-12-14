variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "app_name" {
  type        = string
  description = "Nome da aplicação (repo do GitHub)"
}