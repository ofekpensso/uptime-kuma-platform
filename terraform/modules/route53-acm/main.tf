locals {
  zone_name = trimsuffix(
    lower(var.domain_name),
    "."
  )

  certificate_domain_name = trimsuffix(
    lower(var.certificate_domain_name),
    "."
  )
}

resource "aws_route53_zone" "this" {
  name    = local.zone_name
  comment = "Public hosted zone for ${local.zone_name}"

  tags = merge(
    var.tags,
    {
      Name = local.zone_name
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_acm_certificate" "this" {
  domain_name       = local.certificate_domain_name
  validation_method = "DNS"

  tags = merge(
    var.tags,
    {
      Name = local.certificate_domain_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for option in aws_acm_certificate.this.domain_validation_options :
    option.domain_name => {
      name   = option.resource_record_name
      type   = option.resource_record_type
      record = option.resource_record_value
    }
  }

  zone_id = aws_route53_zone.this.zone_id

  name    = each.value.name
  type    = each.value.type
  ttl     = var.validation_record_ttl
  records = [each.value.record]

  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn

  validation_record_fqdns = [
    for record in aws_route53_record.certificate_validation :
    record.fqdn
  ]
}