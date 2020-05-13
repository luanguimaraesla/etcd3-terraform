data "template_file" "cloud-init" {
  for_each = toset(local.aws_azs)

  template = file("${path.module}/cloudinit/userdata-template.json")

  vars = {
    environment      = var.environment
    role             = var.role
    region           = var.region
    etcd_member_unit = data.template_file.etcd_member_unit[each.value].rendered
    etcd_bootstrap_unit = data.template_file.etcd_bootstrap_unit[each.value].rendered
    ntpdate_unit       = data.template_file.ntpdate_unit.rendered
    ntpdate_timer_unit = data.template_file.ntpdate_timer_unit.rendered
  }
}

data "template_file" "etcd_member_unit" {
  for_each = toset(local.aws_azs)

  template = file("${path.module}/cloudinit/etcd_member_unit")

  vars = {
    peer_name             = "peer-${each.value}"
    discovery_domain_name = "peer-${each.value}.${local.aws_route53_etcd_domain}"
    cluster_name          = local.name
  }
}

data "template_file" "etcd_bootstrap_unit" {
  for_each = toset(local.aws_azs)

  template = file("${path.module}/cloudinit/etcd_bootstrap_unit")

  vars = {
    region                     = var.region
    peer_name                  = "peer-${each.value}"
    discovery_domain_name      = "peer-${each.value}.${local.aws_route53_etcd_domain}"
    etcd3_bootstrap_binary_url = "https://${local.aws_s3_bucket_name}.s3.amazonaws.com/${local.aws_s3_bucket_etcd_bootstrap_key}"
  }
}

data "template_file" "ntpdate_unit" {
  template = file("${path.module}/cloudinit/ntpdate_unit")

  vars = {
    ntp_host = var.ntp_host
  }
}

data "template_file" "ntpdate_timer_unit" {
  template = file("${path.module}/cloudinit/ntpdate_timer_unit")
}

