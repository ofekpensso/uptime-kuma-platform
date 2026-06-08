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
  value       = module.vpc.s3_gateway_endpoint_id
}