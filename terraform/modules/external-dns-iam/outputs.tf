output "role_name" {
  description = "Name of the ExternalDNS Pod Identity IAM role."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "ARN of the ExternalDNS Pod Identity IAM role."
  value       = aws_iam_role.this.arn
}

output "policy_name" {
  description = "Name of the ExternalDNS Route 53 IAM policy."
  value       = aws_iam_policy.this.name
}

output "policy_arn" {
  description = "ARN of the ExternalDNS Route 53 IAM policy."
  value       = aws_iam_policy.this.arn
}

output "namespace" {
  description = "Kubernetes namespace allowed to assume the ExternalDNS IAM role."
  value       = var.namespace
}

output "service_account_name" {
  description = "Kubernetes ServiceAccount allowed to assume the ExternalDNS IAM role."
  value       = var.service_account_name
}

output "managed_record_names" {
  description = "DNS record names that ExternalDNS is allowed to manage."
  value       = local.normalized_record_names
}