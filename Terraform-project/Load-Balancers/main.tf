# APPLICATION LOAD-BALANCER CONFIGURATION 

resource "aws_lb" "webserver_lb" {
  name = var.lb_name
  internal = false
  load_balancer_type = "application"
  security_groups = [var.webserver_sg]
  subnets = tolist(var.public_subnet)
}

# LOAD-BALANCER TARGET-GROUP

resource "aws_lb_target_group" "webserver_lb_tg" {
  name = var.lb_tg_name
  protocol = var.tg_protocol
  port = var.tg_port
  vpc_id = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path                = "/"
    protocol            = var.tg_protocol
    matcher             = var.health_check_matcher
    interval            = var.health_check_interval
    timeout             = var.timeout
    unhealthy_threshold = var.unhealthy_threshold
  }
}

# LOAD-BALANCER LISTENER

resource "aws_lb_listener" "webserver_lb_listener" {
  load_balancer_arn = aws_lb.webserver_lb.arn
  port = var.listener_port
  protocol = var.listener_protocol 
  default_action {
    type = "forward"    
    target_group_arn = aws_lb_target_group.webserver_lb_tg.arn
  }
}

# LOAD-BALANCER LISTENER RULE

resource "aws_lb_listener_rule" "webserver_lb_listener_rule" {
  listener_arn = "${aws_lb_listener.webserver_lb_listener.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.webserver_lb_tg.arn}"
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# LOAD-BALANCER TARGET-GROUP ATTACHMENT

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count = length(var.public_cidrs)
  target_group_arn = aws_lb_target_group.webserver_lb_tg.arn
  target_id        = var.public_server[count.index].id
  port             = var.tg_attachment_port
}

# ROUTE_53 CONFIGURATION FOR DOMAIN NAME

resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name

  tags = {
    Environment = "dev"
  }
}

# ROUTE_53 RECORD

resource "aws_route53_record" "Domain_name" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "terraform-project.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.webserver_lb.dns_name
    zone_id                = aws_lb.webserver_lb.zone_id
    evaluate_target_health = true
  }
}
