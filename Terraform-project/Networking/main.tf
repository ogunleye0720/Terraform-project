# VPC CONFIGURATON SECTION

resource "random_string" "random" {
  length           = 2
  special          = true
  override_special = "/@£$"
}

resource "aws_vpc" "ogunleye_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true


  tags = {
    "Name" = "ogunleye_vpc_${random_string.random.id}"
  }

}

# SUBNET AND ROUTING CONFIGURATION SECTION

resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidrs)
  vpc_id = aws_vpc.ogunleye_vpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"][count.index]


  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count = length(var.public_cidrs)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_internet_gateway" "ogunleye_internet_gateway" {
  vpc_id = aws_vpc.ogunleye_vpc.id

  tags = {
    "Name" = "ogunleye_internet_gateway"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ogunleye_vpc.id

  tags = {
    "Name" = "public_route"
  }
}

resource "aws_route" "public_route" {
 route_table_id = aws_route_table.public_route_table.id
 destination_cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.ogunleye_internet_gateway.id 
}

# WEBSERVER SECURITY GROUP CONFIGURATION SECTION

resource "aws_security_group" "public_instance_sg" {
  name = "public_instance_sg"
  description = "Allow SSH/HTTP inbound traffic"
  vpc_id = aws_vpc.ogunleye_vpc.id

   # ALLOW SSH TRAFFIC FROM REGISTERED IPs

   ingress {
    description = "Allows inbound SSH traffic from registered ip addresses"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.registered_ip]
  }

  # ALLOW HTTP TRAFFIC FROM WEBSERVER(LOAD-BALANCER)

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webserver_sg" {
  name = "webserver_sg"
  description = "Allow HTTP inbound traffic"
  vpc_id = aws_vpc.ogunleye_vpc.id

  ingress {
    description = "Allows inbound HTTP trafic from the internet"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  } 

  egress {
    description = "Allows outbound traffic to the interben"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  } 
}