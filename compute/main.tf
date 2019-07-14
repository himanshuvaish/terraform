data "aws_ami" "server_ami" {
  most_recent=true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_key_pair" "tf_auth" {
  key_name="${var.key_name}"
  public_key="${file(var.public_key_path)}"
}

resource "aws_instance" "tf_server" {
  count         = "${var.instance_count}"
  instance_type = "${var.server_instance_type}"
  ami           = "${data.aws_ami.server_ami.id}"
  tags {
    Name = "tf_server-${count.index +1}_${var.region}"
  }

  key_name               = "${aws_key_pair.tf_auth.id}"
  vpc_security_group_ids = ["${var.private_sg}"]
  subnet_id              = "${element(var.private_subnets, count.index)}"
  #user_data              = "${data.template_file.user-init.*.rendered[count.index]}"

  #provisioner "local-exec" {
   # command = "echo ${aws_instance.tf_server.private_ip} >> private_ips.txt"
  # }
}

resource "aws_lb" "perimeter_network" {
  name               = "perimeternlb"
  load_balancer_type = "network"
  subnets=["${var.public_subnets}"]

tags = {
    Environment = "production_${var.region}"
  }
 }

resource "aws_lb_target_group" "perimeter_tg" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = "${var.vpc}"
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.perimeter_network.arn}"
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.perimeter_tg.arn}"
  }
}

resource "aws_lb_target_group_attachment" "tg-nlb" {
  count="${var.instance_count}"
  target_group_arn = "${aws_lb_target_group.perimeter_tg.arn}"
  target_id        = "${element(aws_instance.tf_server.*.id, count.index)}"
  #"${element(var.private_subnets, count.index)}"
  port             = 80
}
