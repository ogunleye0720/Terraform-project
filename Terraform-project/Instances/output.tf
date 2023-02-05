output "public_server" {
  value = aws_instance.public_server
}

output "instance_ip" {
  value = "${aws_instance.public_server.*.public_ip}"
}