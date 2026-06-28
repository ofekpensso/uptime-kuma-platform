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