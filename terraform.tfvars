project_name = "la-terraform"
vpc_cidr = "192.168.0.0/16"
public_cidrs = [
    "192.168.1.0/24",
    "192.168.2.0/24"
    ]
private_cidrs=[
    "192.168.3.0/24",
    "192.168.4.0/24"
    ]
access_ip = "0.0.0.0/0"
key_name = "tf_key"
public_key_path = "./mytest.pub"
server_instance_type = "t2.micro"
instance_count = 2
dynamodbtable="session-information"
