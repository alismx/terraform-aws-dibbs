locals {
  create_route53_zone = var.route53_zone_name == "" ? false : true
}