output "hosted_zone_id" {
  description = "Route 53 public hosted zone ID."
  value       = aws_route53_zone.this.zone_id
}

output "hosted_zone_arn" {
  description = "Route 53 public hosted zone ARN."
  value       = aws_route53_zone.this.arn
}

output "hosted_zone_name" {
  description = "Route 53 public hosted zone name."
  value       = aws_route53_zone.this.name
}

output "name_servers" {
  description = "Authoritative Route 53 name servers to configure at the domain registrar."
  value       = aws_route53_zone.this.name_servers
}

output "certificate_arn" {
  description = "ARN of the validated ACM certificate."
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "certificate_domain_name" {
  description = "Domain name covered by the ACM certificate."
  value       = aws_acm_certificate.this.domain_name
}

output "certificate_status" {
  description = "Current status of the ACM certificate."
  value       = aws_acm_certificate.this.status
}

output "validation_record_fqdns" {
  description = "Route 53 records used to validate the ACM certificate."

  value = [
    for record in aws_route53_record.certificate_validation :
    record.fqdn
  ]
}