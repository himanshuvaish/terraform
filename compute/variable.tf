variable "key_name" {}

variable "public_key_path" {}

variable "server_instance_type" {}

variable "instance_count" {}

variable "security_group" {}

variable "subnets" {
  type="list"
}

variable "subnet_ips" {
  type="list"
}
