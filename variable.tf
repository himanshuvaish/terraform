variable "aws_region" {}
variable "project_name" {}
#Networking Variables
variable "vpc_cidr" {}

variable "public_cidrs" {
  type="list"
}

variable "private_cidrs" {
  type="list"
}
variable "access_ip" {}

variable "key_name" {}

variable "public_key_path" {}

variable "server_instance_type" {}

variable "instance_count" {}

variable "dynamodbtable"{}
