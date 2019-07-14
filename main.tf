#Define a Provider
#terraform {
#  backend "s3" {}
#}

provider "aws"{
  region="${var.aws_region}"
}

#Deploy Networking Resources
module "networking" {
  source="./networking"
  vpc_cidr="${var.vpc_cidr}"
  access_ip="${var.access_ip}"
  public_cidrs="${var.public_cidrs}"
  private_cidrs="${var.private_cidrs}"
  region="${var.aws_region}"
}

module "storage" {
  source="./storage"
  dynamodbtable="${var.dynamodbtable}"
  region="${var.aws_region}"
}

module "compute"{
  source="./compute"
  instance_count  = "${var.instance_count}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  server_instance_type   = "${var.server_instance_type}"
  public_subnets         = "${module.networking.public_subnets}"
  private_subnets       = "${module.networking.private_subnets}"
  public_sg  = "${module.networking.public_sg}"
  private_sg  = "${module.networking.private_sg}"
  subnet_ips      = "${module.networking.public_subnet_ips}"
  vpc = "${module.networking.vpc}"
  region="${var.aws_region}"
  }
