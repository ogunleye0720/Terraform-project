variable "public_instance_sg" {
  type = string
}
variable "public_cidrs" {}
variable "public_subnets" {
  type = list(any)
}
variable "key_name" {
  type = string
}

variable "webserver_instance_type" {
  type = string
  default = "t2.micro"
}

variable "file_path" {
  type = string
  default = "vagrant/TERRAFORM-PROJECT/host-inventory"
}

variable "instance_ip" {
  type = list(any)
}