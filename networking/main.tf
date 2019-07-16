#Declare Data Source

data "aws_availability_zones" "available" {}

#Configure VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  enable_dns_support= true
  enable_dns_hostnames= true
  tags {
  Createdby="tf"

}}
# Secondary CIDR for VPC
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = "${aws_vpc.tf_vpc.id}"
  cidr_block = "192.169.0.0/16"
}
#Configure IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.tf_vpc.id}"

  tags = {
    Name = "igw_tf_${var.region}"
  }
}
#Configure Private Subnets
resource "aws_subnet" "tf_private_subnet"{
  count=2
  availability_zone="${data.aws_availability_zones.available.names[count.index]}"
  cidr_block="${var.private_cidrs[count.index]}"
  vpc_id="${aws_vpc.tf_vpc.id}"

  tags {
   Name="tf_private_${count.index+1}_${var.region}"
  }

}
#Configure Public Subnets
resource "aws_subnet" "tf_public_subnet"{
  count=2
  map_public_ip_on_launch=true
  availability_zone="${data.aws_availability_zones.available.names[count.index]}"
  cidr_block="${var.public_cidrs[count.index]}"
  vpc_id="${aws_vpc.tf_vpc.id}"

  tags {
   Name="tf_public_${count.index+1}_${var.region}"
  }

}
#Configure Route Tables
resource "aws_route_table" "tf_public_rt" {
  vpc_id = "${aws_vpc.tf_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "tf_public_${var.region}"
  }
}

resource "aws_route_table" "tf_private_rt" {
  vpc_id = "${aws_vpc.tf_vpc.id}"

  tags {
    Name = "tf_private_${var.region}"
  }
}

#Create Association between Public Route Table and Subnet
resource "aws_route_table_association" "tf_public_assoc" {
  count          = "${aws_subnet.tf_public_subnet.count}"
  subnet_id      = "${aws_subnet.tf_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.tf_public_rt.id}"
}

#Create Association between Private Route Table and Subnet
resource "aws_route_table_association" "tf_private_assoc" {
  count          = "${aws_subnet.tf_private_subnet.count}"
  subnet_id      = "${aws_subnet.tf_private_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.tf_private_rt.id}"
}

#Create Public SG
resource "aws_security_group" "tf_public_SG" {
  name        = "tf_public_sg"
  description = "Used for access to the public instances"
  vpc_id="${aws_vpc.tf_vpc.id}"
 #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.access_ip}"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self=true
  }
  #RDP

    ingress {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = ["${var.access_ip}"]
      self=true
    }
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]

  }
}

#Create Private SG
resource "aws_security_group" "tf_private_SG" {
  name        = "tf_private_sg"
  description = "Used for access to the private instances"
  vpc_id="${aws_vpc.tf_vpc.id}"
 #SSH
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups=["${aws_security_group.tf_public_SG.id}"]
    self=true
    cidr_blocks=["${var.vpc_cidr}"]

  }
}
