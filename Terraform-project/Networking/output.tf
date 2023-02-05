output "vpc_id" {
  value = aws_vpc.ogunleye_vpc.id
}

output "webserver_sg" {
  value = aws_security_group.webserver_sg.id
}

output "public_subnet" {
  value = "${aws_subnet.public_subnet.*.id}"
}

output "public_instance_sg" {
  value = aws_security_group.public_instance_sg.id
}
