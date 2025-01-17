data "template_file" "cloud-init" {
  for_each = toset(local.aws_azs)

  template = file("${path.module}/cloudinit/userdata-template.sh")

  vars = {
    etcd_version     = local.etcd_version
    etcd_member_unit = data.template_file.etcd_member_unit[each.value].rendered
    etcd_bootstrap_unit = data.template_file.etcd_bootstrap_unit[each.value].rendered
  }
}

data "template_file" "etcd_member_unit" {
  for_each = toset(local.aws_azs)

  template = file("${path.module}/cloudinit/etcd_member_unit")

  vars = {
    peer_name             = "peer-${each.value}"
    discovery_domain_name = local.aws_route53_etcd_domain
    cluster_name          = local.name
  }
}

data "template_file" "etcd_bootstrap_unit" {
  for_each = toset(local.aws_azs)

  template = file("${path.module}/cloudinit/etcd_bootstrap_unit")

  vars = {
    peer_domain                = "peer-${each.value}.${local.aws_route53_etcd_domain}" 
    hosted_zone_id             = local.aws_route53_zone_id
    region                     = local.aws_region
    peer_ebs_volume_name       = "vol-peer-${each.value}.${local.aws_route53_etcd_domain}"
    etcd3_bootstrap_binary_url = "https://${local.aws_s3_bucket_name}.s3.amazonaws.com/${local.aws_s3_bucket_etcd_bootstrap_key}"
  }
}
