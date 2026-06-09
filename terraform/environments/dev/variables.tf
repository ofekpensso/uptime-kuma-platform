variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "uptime-kuma"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "owner" {
  description = "Owner of the resources."
  type        = string
  default     = "ofek"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones to use."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_data_subnet_cidrs" {
  description = "CIDR blocks for private data subnets."
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway."
  type        = bool
  default     = true
}

variable "enable_s3_gateway_endpoint" {
  description = "Whether to create an S3 Gateway VPC Endpoint."
  type        = bool
  default     = true
}

variable "app_port" {
  description = "Application port exposed by Uptime Kuma."
  type        = number
  default     = 3001
}

variable "database_port" {
  description = "PostgreSQL database port."
  type        = number
  default     = 5432
}

variable "allowed_http_cidr_blocks" {
  description = "CIDR blocks allowed to access ALB on HTTP."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_https_cidr_blocks" {
  description = "CIDR blocks allowed to access ALB on HTTPS."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}