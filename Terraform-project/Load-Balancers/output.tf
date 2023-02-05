output "webserver_lb" {
    value = aws_lb.webserver_lb.id
}

output "webserver_lb_tg_arn" {
  value = aws_lb_target_group.webserver_lb_tg.arn
}

output "webserver_lb_tg" {
    value = aws_lb_target_group.webserver_lb_tg.id
}

output "webserver_lb_dns" {
  value = aws_lb.webserver_lb.dns_name
}