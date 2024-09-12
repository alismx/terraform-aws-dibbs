resource "aws_route53_zone" "this" {
  count = local.create_route53_zone ? 1 : 0
  name = var.route53_zone_name
}

resource "aws_route53_record" "RECORDNAME" {
  zone_id = local.create_route53_zone ? aws_route53_zone.this[0].zone_id : var.route53_zone_id
  name    = var.route53_record_name
  type    = "A"
  alias {
    name                   = aws_elb.main.dns_name
    zone_id                = aws_elb.main.zone_id
    evaluate_target_health = true
  }
}