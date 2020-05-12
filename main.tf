
locals {
  # general
  default_tags = {
    Role = var.role
  }
  tags = merge(local.default_tags, var.tags)

  # vpc
  aws_vpc_id = var.vpc_id
  aws_vpc_cidr_block = var.vpc_cidr_block

  # security groups
  aws_security_group_name = "${var.role}.${var.dns["domain_name"]}"

  # s3
  aws_s3_bucket_name = var.s3_bucket_name
  aws_s3_bucket_etcd_bootstrap_key = "${var.s3_bucket_prefix}/etcd3-bootstrap-linux-amd64"
}
