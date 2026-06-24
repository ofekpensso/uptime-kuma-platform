output "role_arn" {
  description = "ARN of the AWS Load Balancer Controller IAM role."
  value       = aws_iam_role.this.arn
}

output "policy_arn" {
  description = "ARN of the AWS Load Balancer Controller IAM policy."
  value       = aws_iam_policy.this.arn
}

output "association_id" {
  description = "ID of the EKS Pod Identity association."
  value       = aws_eks_pod_identity_association.this.association_id
}