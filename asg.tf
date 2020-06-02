resource "aws_launch_configuration" "default" {
  for_each = toset(local.aws_azs)

  name_prefix                 = "peer-${each.value}.${local.aws_route53_etcd_domain}-"
  image_id                    = local.aws_ami
  instance_type               = local.aws_instance_type
  ebs_optimized               = true
  iam_instance_profile        = aws_iam_instance_profile.default.id
  key_name                    = local.aws_key_name
  enable_monitoring           = false
  associate_public_ip_address = true
  user_data                   = data.template_file.cloud-init[each.value].rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "default" {
  for_each = toset(local.aws_azs)

  vpc_zone_identifier       = [local.aws_azs_subnet_ids[each.value]]
  name                      = "peer-${each.value}.${local.aws_route53_etcd_domain}"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.default[each.value].name
  load_balancers            = [aws_elb.internal.name]
  wait_for_capacity_timeout = "0"

  tag {
    key                 = "Name"
    value               = "peer-${each.value}.${local.aws_route53_etcd_domain}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = local.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "cluster"
    value               = local.name
    propagate_at_launch = true
  }

  tag {
    key                 = "r53-domain-name"
    value               = "peer-${each.value}.${local.aws_route53_etcd_domain}"
    propagate_at_launch = false
  }

  tag {
    key                 = "r53-zone-id"
    value               = local.aws_route53_zone_id
    propagate_at_launch = false
  }
}

resource "aws_ebs_volume" "ssd" {
  for_each = toset(local.aws_azs)

  type              = "gp2"
  availability_zone = each.value
  size              = 100
  tags = merge(local.tags, {"Name": "vol-peer-${each.value}.${local.aws_route53_etcd_domain}"})
}



