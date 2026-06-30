output "association_id" {
  description = "ID of the EKS Pod Identity association."
  value       = aws_eks_pod_identity_association.this.association_id
}

output "cluster_name" {
  description = "Name of the EKS cluster associated with the IAM role."
  value       = var.cluster_name
}

output "namespace" {
  description = "Kubernetes namespace associated with the IAM role."
  value       = var.namespace
}

output "service_account_name" {
  description = "Kubernetes ServiceAccount associated with the IAM role."
  value       = var.service_account_name
}

output "role_arn" {
  description = "IAM role ARN assigned through EKS Pod Identity."
  value       = var.role_arn
}