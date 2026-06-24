variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC."
  type        = string
}

variable "app_port" {
  description = "Application port exposed by the Kubernetes service/pods."
  type        = number
  default     = 3001
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

variable "tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default     = {}
}

variable "eks_node_security_group_id" {
  description = "Actual EKS node security group ID allowed to access RDS."
  type        = string
}