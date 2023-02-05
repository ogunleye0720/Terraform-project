data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "public_server" {
  count = length(var.public_cidrs)
  ami = data.aws_ami.ubuntu.id
  subnet_id = var.public_subnets[count.index]
  instance_type = var.webserver_instance_type
  vpc_security_group_ids = [var.public_instance_sg]
  key_name = var.key_name

  tags = {
    "Name" = "public_server_${count.index + 1}"
  }
}

# Exporting instance public ip address to local file

resource "local_file" "Ip_address" {
  filename = "vagrant/Terraform-project/ansible_playbook/host-inventory"
  content = templatefile("templates/inventory.tftpl", {
    elastic = tomap({
      for instance in aws_instance.public_server:
       instance.tags.Name => instance.public_ip
    })
  })
}