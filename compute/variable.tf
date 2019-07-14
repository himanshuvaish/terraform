variable "key_name" {}

variable "public_key_path" {}

variable "server_instance_type" {}

variable "instance_count" {}

variable "public_sg" {}

variable "private_sg" {}

variable "private_subnets" {
  type="list"
}
variable "public_subnets" {
  type="list"
}

variable "subnet_ips" {
  type="list"
}

variable "vpc" {}

variable "region" {}
