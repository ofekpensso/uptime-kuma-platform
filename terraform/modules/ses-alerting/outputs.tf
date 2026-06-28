output "email_identity" {
  description = "SES email identity."
  value       = aws_sesv2_email_identity.this.email_identity
}

output "verification_status" {
  description = "SES identity verification status."
  value       = aws_sesv2_email_identity.this.verification_status
}

output "email_identity_arn" {
  description = "ARN of the SES email identity."
  value       = local.ses_identity_arn
}

output "smtp_endpoint" {
  description = "Regional SES SMTP endpoint."
  value       = "${local.smtp_host}:${var.smtp_port}"
}

output "iam_user_name" {
  description = "IAM user used for SMTP authentication."
  value       = aws_iam_user.smtp.name
}

output "secret_name" {
  description = "Secrets Manager secret name containing SMTP credentials."
  value       = aws_secretsmanager_secret.smtp.name
}

output "secret_arn" {
  description = "Secrets Manager secret ARN containing SMTP credentials."
  value       = aws_secretsmanager_secret.smtp.arn
}