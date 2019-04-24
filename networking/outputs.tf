#-----networking/outputs.tf

output "public_subnets" {
  value = "${aws_subnet.tf_public_subnet.*.id}"
}

output "private_subnets" {
  value = "${aws_subnet.tf_private_subnet.*.id}"
}

output "public_sg" {
  value = "${aws_security_group.tf_public_SG.id}"
}

output "private_sg" {
  value = "${aws_security_group.tf_private_SG.id}"
}

output "public_subnet_ips" {
  value = "${aws_subnet.tf_public_subnet.*.cidr_block}"
}
output "private_subnet_ips" {
  value = "${aws_subnet.tf_private_subnet.*.cidr_block}"
}
