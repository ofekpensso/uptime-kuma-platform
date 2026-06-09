output "secret_id" {
  description = "Secrets Manager secret ID."
  value       = aws_secretsmanager_secret.this.id
}

output "secret_arn" {
  description = "Secrets Manager secret ARN."
  value       = aws_secretsmanager_secret.this.arn
}

output "password" {
  description = "Generated password."
  value       = random_password.this.result
  sensitive   = true
}