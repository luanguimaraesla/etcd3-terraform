resource "aws_route53_record" "default" {
  zone_id = local.aws_route53_zone_id
  name    = local.aws_route53_etcd_srv_domain
  type    = "SRV"
  ttl     = "1"
  records = formatlist("0 0 2380 %s", [
    for rec in values(aws_route53_record.peers):
      rec.name
  ])
}

resource "aws_route53_record" "peers" {
  for_each = toset(local.aws_azs)

  zone_id = local.aws_route53_zone_id
  name    = "peer-${each.value}.${local.aws_route53_etcd_domain}"
  type    = "A"
  ttl     = "1"
  records = ["127.0.0.1"]
}
