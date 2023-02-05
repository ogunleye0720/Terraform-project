variable "public_subnet" {
  type = list(string)
}
variable "vpc_id" {}
variable "webserver_sg" {}
variable "public_server" {}
variable "public_cidrs" {}

variable "lb_name" {
  type = string
  default = "ogunleye-webserver"
}

variable "lb_type" {
  type = string
  default = "applicaton"
}

variable "lb_tg_name" {
  type = string
  default = "websever-tg"
}

variable "tg_protocol" {
  type = string
  default = "HTTP"
}

variable "tg_port" {
  default = 80
}

variable "tg_attachment_port" {
  default = 80
}

variable "listener_protocol" {
  type = string
  default = "HTTP"
}

variable "listener_port" {
  default = 80
}

variable "health_check_interval" {
  default = 15
}

variable "timeout" {
  default = 5
}

variable "unhealthy_threshold" {
  default = 5
}

variable "health_check_matcher" {
  type = string
  default = "200"
}

variable "domain_name" {
  description = "Stores desired domain name for the webserver"
  type= string
  default = "ogunleye1995.me"
}