variable "aws_region" {
  default = "us-east-1"
}

variable "app_name" {
  description = "Nome da aplicação / repositório ECR"
}

variable "image_tag" {
  description = "Tag da imagem (ex: github.sha)"
}

variable "container_port" {
  default = 3000
}
