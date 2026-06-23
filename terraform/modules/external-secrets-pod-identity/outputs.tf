output "role_name" {
  description = "Name of the IAM role used by External Secrets Operator."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "ARN of the IAM role used by External Secrets Operator."
  value       = aws_iam_role.this.arn
}

output "policy_arn" {
  description = "ARN of the Secrets Manager read policy."
  value       = aws_iam_policy.secrets_manager_read.arn
}

output "pod_identity_association_id" {
  description = "ID of the EKS Pod Identity association."
  value       = aws_eks_pod_identity_association.this.association_id
}

output "namespace" {
  description = "Kubernetes namespace associated with the IAM role."
  value       = var.namespace
}

output "service_account_name" {
  description = "Kubernetes ServiceAccount associated with the IAM role."
  value       = var.service_account_name
}