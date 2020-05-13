
locals {

  # general
  name = "${var.name}.etcd"
  default_tags = {
    Name = local.name
  }
  tags = merge(local.default_tags, var.tags)

  # vpc
  aws_vpc_id = var.vpc_id
  aws_vpc_cidr_block = var.vpc_cidr_block
  aws_azs = var.aws_azs
  aws_azs_ids = var.azs_ids

  # security groups
  aws_security_group_name = "${var.name}.${var.dns["domain_name"]}"

  # s3
  aws_s3_bucket_name = var.s3_bucket_name
  aws_s3_bucket_etcd_bootstrap_key = "${var.s3_bucket_prefix}/etcd3-bootstrap-linux-amd64"

  # route53
  aws_route53_etcd_domain = "${var.name}.${var.dns["domain_name"]}"
  aws_route53_etcd_srv_domain = "_etcd._tcp.${local.aws_route53_etcd_domain}"
  aws_route53_zone_id = var.route53_zone_id

  # lambda
  aws_lambda_name = "${var.name}.${var.dns["domain_name"]}"

  # lauchconfiguration
  aws_ami = var.ami
  aws_key_name = var.keyname
  aws_instance_type = var.instance_type
}
