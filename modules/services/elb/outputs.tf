output "elb_name"{
    value = aws_lb.alb.name
}

output "elb_id"{
    value = aws_lb.alb.id
}

output "elb_dns"{
    value = aws_lb.alb.dns_name
}

output "aws_lb_fronted_http_tcp_listener_arn"{
    value = aws_lb_listener.frontend_http_tcp[*].arn
}

output "aws_lb_fronted_http_tcp_listener_id"{
    value = aws_lb_listener.frontend_http_tcp[*].id
}

output "aws_lb_fronted_https_listener_arn"{
    value = aws_lb_listener.frontend_https[*].arn
}

output "aws_lb_fronted_https_listener_id"{
    value = aws_lb_listener.frontend_https[*].id
}

output "target_group_name"{
    value = aws_lb_target_group.instance_tg[*].name
}

output "target_group_arn"{
    value = aws_lb_target_group.instance_tg[*].id
}
output "target_group_port"{
    value = aws_lb_target_group.instance_tg[*].port
}


output "elb_sg_id" {
  value = aws_security_group.elb[*].id
}