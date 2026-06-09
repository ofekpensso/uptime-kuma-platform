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

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.35"
}

variable "eks_endpoint_public_access" {
  description = "Whether the EKS API endpoint is publicly accessible."
  type        = bool
  default     = true
}

variable "eks_endpoint_private_access" {
  description = "Whether the EKS API endpoint is privately accessible from inside the VPC."
  type        = bool
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Whether to grant the Terraform caller admin permissions in the EKS cluster."
  type        = bool
  default     = true
}

variable "eks_node_instance_types" {
  description = "Instance types for the default EKS managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_capacity_type" {
  description = "Capacity type for the default EKS managed node group."
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.eks_node_capacity_type)
    error_message = "eks_node_capacity_type must be either ON_DEMAND or SPOT."
  }
}

variable "eks_node_min_size" {
  description = "Minimum number of nodes in the default EKS managed node group."
  type        = number
  default     = 1
}

variable "eks_node_desired_size" {
  description = "Desired number of nodes in the default EKS managed node group."
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum number of nodes in the default EKS managed node group."
  type        = number
  default     = 2
}

variable "eks_node_disk_size" {
  description = "Disk size in GB for worker nodes."
  type        = number
  default     = 30
}

variable "enable_spot_node_group" {
  description = "Whether to create an optional Spot managed node group."
  type        = bool
  default     = false
}

variable "eks_spot_instance_types" {
  description = "Instance types for the optional Spot managed node group."
  type        = list(string)
  default     = ["t3.medium", "t3a.medium"]
}

variable "eks_authentication_mode" {
  description = "EKS cluster authentication mode."
  type        = string
  default     = "API_AND_CONFIG_MAP"

  validation {
    condition     = contains(["CONFIG_MAP", "API_AND_CONFIG_MAP", "API"], var.eks_authentication_mode)
    error_message = "eks_authentication_mode must be CONFIG_MAP, API_AND_CONFIG_MAP, or API."
  }
}

# -----------------------------------------------------------------------------
# RDS
# -----------------------------------------------------------------------------

variable "db_engine" {
  description = "RDS engine."
  type        = string
  default     = "mariadb"
}

variable "db_engine_version" {
  description = "RDS engine version."
  type        = string
  default     = null
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB."
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "RDS max allocated storage in GB."
  type        = number
  default     = 50
}

variable "db_name" {
  description = "Application database name."
  type        = string
  default     = "uptimekuma"
}

variable "db_username" {
  description = "RDS master username."
  type        = string
  default     = "uptimekuma_admin"
}

variable "db_port" {
  description = "RDS database port."
  type        = number
  default     = 3306
}

variable "db_multi_az" {
  description = "Enable RDS Multi-AZ."
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "RDS backup retention in days."
  type        = number
  default     = 1
}

variable "db_deletion_protection" {
  description = "Enable RDS deletion protection."
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# ECR
# -----------------------------------------------------------------------------

variable "ecr_repository_name" {
  description = "Name of the ECR repository."
  type        = string
  default     = "uptime-kuma"
}

variable "ecr_image_tag_mutability" {
  description = "Image tag mutability setting for the ECR repository."
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.ecr_image_tag_mutability)
    error_message = "ecr_image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "ecr_scan_on_push" {
  description = "Enable ECR image scan on push."
  type        = bool
  default     = true
}

variable "ecr_force_delete" {
  description = "Delete the ECR repository even if it contains images."
  type        = bool
  default     = true
}

variable "ecr_keep_last_images" {
  description = "Number of tagged images to keep in ECR."
  type        = number
  default     = 10
}

variable "ecr_lifecycle_tag_prefixes" {
  description = "List of ECR tag prefixes that lifecycle policy applies to."
  type        = list(string)
  default     = ["sha-"]
}