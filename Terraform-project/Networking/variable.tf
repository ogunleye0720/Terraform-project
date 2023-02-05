variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_cidrs" {
  type = list(any)
}

variable "registered_ip" {
  description = "by default allows all ip address access into the server"
  type = string
  default = "0.0.0.0/0"
  sensitive = true
}