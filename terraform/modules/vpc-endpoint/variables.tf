variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for Interface VPC Endpoints."
  type        = list(string)
}

variable "route_table_ids" {
  description = "Route table IDs for Gateway VPC Endpoints."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for Interface VPC Endpoints."
  type        = list(string)
}

variable "enable_s3_gateway_endpoint" {
  description = "Whether to create an S3 Gateway VPC Endpoint."
  type        = bool
  default     = true
}

variable "enable_ecr_api_endpoint" {
  description = "Whether to create an ECR API Interface VPC Endpoint."
  type        = bool
  default     = true
}

variable "enable_ecr_dkr_endpoint" {
  description = "Whether to create an ECR Docker Interface VPC Endpoint."
  type        = bool
  default     = true
}

variable "private_dns_enabled" {
  description = "Whether to enable private DNS for Interface Endpoints."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to VPC endpoint resources."
  type        = map(string)
  default     = {}
}