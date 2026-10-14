variable "project" {
  type    = string
  default = "personnes"
}

variable "region" {
  type    = string
  default = "us-east-1" # eu-west-3 Paris
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "db_name" {
  type    = string
  default = "personnes"
}

variable "db_username" {
  type    = string
  default = "pgadmin"
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

# 0 au premier apply (les images n'existent pas encore dans ECR), puis 1 ou plus
variable "desired_count" {
  type    = number
  default = 0
}
