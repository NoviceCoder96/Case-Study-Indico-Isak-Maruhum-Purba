variable "project_name" {}
variable "environment" {}
variable "container_image" {}
variable "subnets" { type = list(string) }
variable "security_group" {}