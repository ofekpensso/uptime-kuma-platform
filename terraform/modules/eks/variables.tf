variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.35"
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS managed node groups."
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Whether the EKS cluster API endpoint is publicly accessible."
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Whether the EKS cluster API endpoint is privately accessible inside the VPC."
  type        = bool
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Whether to grant the Terraform caller admin permissions in the EKS cluster."
  type        = bool
  default     = true
}

variable "node_instance_types" {
  description = "EC2 instance types for the default EKS managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_capacity_type" {
  description = "Capacity type for the default EKS managed node group. Use ON_DEMAND for stability, SPOT for cost optimization."
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type must be either ON_DEMAND or SPOT."
  }
}

variable "node_min_size" {
  description = "Minimum number of nodes in the default node group."
  type        = number
  default     = 1
}

variable "node_desired_size" {
  description = "Desired number of nodes in the default node group."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of nodes in the default node group."
  type        = number
  default     = 2
}

variable "node_disk_size" {
  description = "Disk size in GB for worker nodes."
  type        = number
  default     = 30
}

variable "enable_spot_node_group" {
  description = "Whether to create an optional Spot managed node group for non-critical workloads."
  type        = bool
  default     = false
}

variable "spot_instance_types" {
  description = "EC2 instance types for the optional Spot node group."
  type        = list(string)
  default     = ["t3.medium", "t3a.medium"]
}

variable "tags" {
  description = "Additional tags to apply to EKS resources."
  type        = map(string)
  default     = {}
}

variable "authentication_mode" {
  description = "EKS cluster authentication mode."
  type        = string
  default     = "API_AND_CONFIG_MAP"

  validation {
    condition     = contains(["CONFIG_MAP", "API_AND_CONFIG_MAP", "API"], var.authentication_mode)
    error_message = "authentication_mode must be CONFIG_MAP, API_AND_CONFIG_MAP, or API."
  }
}

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