output "Public Security Group" {
  value = "${module.networking.public_sg}"
}

output "Private Security Group" {
  value = "${module.networking.private_sg}"
}

output "Public Subnets" {
  value = "${join(", ", module.networking.public_subnets,module.networking.public_subnet_ips)}"
}

output "Private Subnets" {
  value = "${join(", ", module.networking.private_subnets, module.networking.private_subnet_ips)}"
}
