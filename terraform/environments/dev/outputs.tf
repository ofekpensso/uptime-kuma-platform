output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets."
  value       = module.vpc.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "IDs of the private data subnets."
  value       = module.vpc.private_data_subnet_ids
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway."
  value       = module.vpc.nat_gateway_id
}

output "s3_gateway_endpoint_id" {
  description = "ID of the S3 Gateway VPC Endpoint."
  value       = module.vpc_endpoints.s3_gateway_endpoint_id
}

output "ecr_api_endpoint_id" {
  description = "ID of the ECR API Interface VPC Endpoint."
  value       = module.vpc_endpoints.ecr_api_endpoint_id
}

output "ecr_dkr_endpoint_id" {
  description = "ID of the ECR Docker Interface VPC Endpoint."
  value       = module.vpc_endpoints.ecr_dkr_endpoint_id
}

output "alb_security_group_id" {
  description = "ID of the ALB security group."
  value       = module.security_groups.alb_security_group_id
}

output "eks_security_group_id" {
  description = "ID of the EKS security group."
  value       = module.security_groups.eks_security_group_id
}

output "vpc_endpoints_security_group_id" {
  description = "ID of the VPC Endpoints security group."
  value       = module.security_groups.vpc_endpoints_security_group_id
}

output "eks_cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS cluster Kubernetes version."
  value       = module.eks.cluster_version
}

output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID."
  value       = module.eks.cluster_security_group_id
}

output "eks_node_security_group_id" {
  description = "EKS node security group ID."
  value       = module.eks.node_security_group_id
}

output "eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN for IRSA."
  value       = module.eks.oidc_provider_arn
}

output "ecr_repository_name" {
  description = "ECR repository name."
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "ECR repository URL."
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ECR repository ARN."
  value       = module.ecr.repository_arn
}

output "github_actions_role_arn" {
  description = "IAM role ARN used by GitHub Actions to push images to ECR."
  value       = module.github_oidc.github_actions_role_arn
}

output "github_oidc_provider_arn" {
  description = "GitHub OIDC provider ARN."
  value       = module.github_oidc.github_oidc_provider_arn
}

output "aws_load_balancer_controller_role_arn" {
  description = "IAM role ARN used by AWS Load Balancer Controller."
  value = (
    module.aws_load_balancer_controller_pod_identity.role_arn
  )
}

output "aws_load_balancer_controller_policy_arn" {
  description = "IAM policy ARN used by AWS Load Balancer Controller."
  value = (
    module.aws_load_balancer_controller_pod_identity.policy_arn
  )
}

output "aws_load_balancer_controller_pod_identity_association_id" {
  description = "EKS Pod Identity association ID for the controller."
  value = (
    module.aws_load_balancer_controller_pod_identity.association_id
  )
}

output "external_dns_role_arn" {
  description = "ARN of the persistent IAM role used by ExternalDNS."
  value       = data.aws_iam_role.external_dns.arn
}

output "external_dns_pod_identity_association_id" {
  description = "ID of the ExternalDNS EKS Pod Identity association."
  value       = module.external_dns_pod_identity_association.association_id
}

output "external_dns_namespace" {
  description = "Kubernetes namespace in which ExternalDNS runs."
  value       = module.external_dns_pod_identity_association.namespace
}

output "external_dns_service_account_name" {
  description = "Kubernetes ServiceAccount used by ExternalDNS."
  value       = module.external_dns_pod_identity_association.service_account_name
}