output "secret_name" {
  description = "Name of the AWS Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.name
}

output "secret_arn" {
  description = "ARN of the AWS Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.arn
}

output "admin_user" {
  description = "Grafana administrator username."
  value       = var.admin_user
}