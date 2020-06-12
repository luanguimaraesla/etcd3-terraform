data "aws_region" "region" {} 

locals {
  # etcd
  etcd_version = var.etcd_version

  # general
  name = "${var.name}.etcd"
  default_tags = {
    Name = local.name
    cluster = var.name
  }
  tags = merge(local.default_tags, var.tags)

  # region
  aws_region = data.aws_region.region.name 

  # vpc
  aws_vpc_id = var.vpc_id
  aws_vpc_cidr_block = var.vpc_cidr_block
  aws_azs_subnet_ids = var.azs_subnet_ids 
  aws_azs = [for name, id in local.aws_azs_subnet_ids: name]
  aws_subnet_ids = [for name, id in local.aws_azs_subnet_ids: id]

  # security groups
  aws_security_group_name = "${local.name}.${var.dns["domain_name"]}"

  # s3
  aws_s3_bucket_name = var.s3_bucket_name
  aws_s3_bucket_etcd_bootstrap_key = "${var.s3_bucket_prefix}/etcd3-bootstrap-linux-amd64"

  # route53
  aws_route53_zone_id = var.dns["zone_id"]
  aws_route53_etcd_domain = "${local.name}.${var.dns["domain_name"]}"
  aws_route53_etcd_srv_domain = "_etcd-server._tcp.${local.aws_route53_etcd_domain}"

  # lauchconfiguration
  aws_ami = var.ami
  aws_key_name = var.key_name
  aws_instance_type = var.instance_type

  # elb
  aws_elb_record = "internal.${local.aws_route53_etcd_domain}"
  aws_elb_name = "${lower(replace(local.name,"/\\W|_|\\s/","-"))}"
}
