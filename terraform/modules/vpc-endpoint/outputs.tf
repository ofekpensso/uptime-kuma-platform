output "s3_gateway_endpoint_id" {
  description = "S3 Gateway VPC Endpoint ID."
  value       = var.enable_s3_gateway_endpoint ? aws_vpc_endpoint.s3[0].id : null
}

output "ecr_api_endpoint_id" {
  description = "ECR API Interface VPC Endpoint ID."
  value       = var.enable_ecr_api_endpoint ? aws_vpc_endpoint.ecr_api[0].id : null
}

output "ecr_dkr_endpoint_id" {
  description = "ECR Docker Interface VPC Endpoint ID."
  value       = var.enable_ecr_dkr_endpoint ? aws_vpc_endpoint.ecr_dkr[0].id : null
}