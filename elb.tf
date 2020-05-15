resource "aws_elb" "internal" {
  name                      = local.aws_elb_name
  security_groups           = [aws_security_group.default.id]
  cross_zone_load_balancing = true
  subnets                   = local.aws_subnet_ids
  internal                  = true
  idle_timeout              = 3600

  listener {
    instance_port     = 2379
    instance_protocol = "tcp"
    lb_port           = 2379
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    target              = "HTTP:2379/health"
    interval            = 10
  }

  tags = local.tags
}

resource "aws_route53_record" "internal" {
  zone_id = local.aws_route53_zone_id
  name    = local.aws_elb_record
  type    = "A"

  alias {
    name                   = aws_elb.internal.dns_name
    zone_id                = aws_elb.internal.zone_id
    evaluate_target_health = false
  }
}

