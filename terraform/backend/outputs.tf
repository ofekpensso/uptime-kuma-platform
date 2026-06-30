output "state_bucket_name" {
  description = "Name of the S3 bucket used for Terraform remote state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket used for Terraform remote state."
  value       = aws_s3_bucket.terraform_state.arn
}

output "aws_region" {
  description = "AWS region where the backend resources were created."
  value       = var.aws_region
}

output "backend_key_example" {
  description = "Example backend key for the backend root module state."
  value       = "${var.project_name}/backend/terraform.tfstate"
}

output "ses_email_identity" {
  description = "SES email identity used by Alertmanager."
  value       = module.ses_alerting.email_identity
}

output "ses_verification_status" {
  description = "Current SES email identity verification status."
  value       = module.ses_alerting.verification_status
}

output "ses_smtp_endpoint" {
  description = "SES SMTP endpoint used by Alertmanager."
  value       = module.ses_alerting.smtp_endpoint
}

output "alertmanager_smtp_secret_name" {
  description = "Secrets Manager secret containing Alertmanager SMTP credentials."
  value       = module.ses_alerting.secret_name
}

output "alertmanager_smtp_secret_arn" {
  description = "ARN of the Alertmanager SMTP credentials secret."
  value       = module.ses_alerting.secret_arn
}

output "grafana_admin_secret_name" {
  description = "Secrets Manager secret containing Grafana admin credentials."
  value       = module.grafana_admin_credentials.secret_name
}

output "grafana_admin_secret_arn" {
  description = "ARN of the Grafana admin credentials secret."
  value       = module.grafana_admin_credentials.secret_arn
}

output "grafana_admin_user" {
  description = "Grafana administrator username."
  value       = module.grafana_admin_credentials.admin_user
}

output "route53_hosted_zone_id" {
  description = "ID of the Route 53 public hosted zone."
  value       = module.route53_acm.hosted_zone_id
}

output "route53_hosted_zone_arn" {
  description = "ARN of the Route 53 public hosted zone."
  value       = module.route53_acm.hosted_zone_arn
}

output "route53_name_servers" {
  description = "Authoritative Route 53 name servers to configure in Namecheap."
  value       = module.route53_acm.name_servers
}

output "application_domain_name" {
  description = "Public domain name used by Uptime Kuma."
  value       = local.application_domain_name
}

output "acm_certificate_arn" {
  description = "ARN of the validated ACM certificate used by the ALB."
  value       = module.route53_acm.certificate_arn
}

output "acm_certificate_status" {
  description = "Current status of the ACM certificate."
  value       = module.route53_acm.certificate_status
}

output "acm_validation_record_fqdns" {
  description = "DNS records used to validate the ACM certificate."
  value       = module.route53_acm.validation_record_fqdns
}

output "external_dns_role_name" {
  description = "Name of the IAM role used by ExternalDNS through EKS Pod Identity."
  value       = module.external_dns_iam.role_name
}

output "external_dns_role_arn" {
  description = "ARN of the IAM role used by ExternalDNS through EKS Pod Identity."
  value       = module.external_dns_iam.role_arn
}

output "external_dns_policy_arn" {
  description = "ARN of the IAM policy that grants ExternalDNS access to Route 53."
  value       = module.external_dns_iam.policy_arn
}

output "external_dns_namespace" {
  description = "Kubernetes namespace in which ExternalDNS runs."
  value       = module.external_dns_iam.namespace
}

output "external_dns_service_account_name" {
  description = "Kubernetes ServiceAccount used by ExternalDNS."
  value       = module.external_dns_iam.service_account_name
}

output "external_dns_managed_record_names" {
  description = "DNS record names that ExternalDNS is allowed to manage."
  value       = module.external_dns_iam.managed_record_names
}