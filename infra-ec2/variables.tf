variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "app_name" {
  type        = string
  description = "Nome da aplicação (repo do GitHub)"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "associate_public_ip" {
  type    = bool
  default = false
}

variable "allow_ssh" {
  type    = bool
  default = false
}

variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}