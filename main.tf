#Define a Provider
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraformpipelinehimanshu"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    # Replace this with your DynamoDB table name!
    #dynamodb_table = "terraform-up-and-running-locks"
    #encrypt        = true
  }
}
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
}

module "storage" {
  source="./storage"
  bucket_name="${var.bucket_name}"
}

module "compute"{
  source="./compute"
  instance_count  = "${var.instance_count}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  server_instance_type   = "${var.server_instance_type}"
  subnets         = "${module.networking.public_subnets}"
  security_group  = "${module.networking.public_sg}"
  subnet_ips      = "${module.networking.public_subnet_ips}"
}
