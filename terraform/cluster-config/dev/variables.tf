variable "aws_region" {
  description = "AWS region containing the EKS cluster."
  type        = string
  default     = "us-east-1"
}

variable "infrastructure_state_bucket" {
  description = "S3 bucket containing the infrastructure Terraform state."
  type        = string
}

variable "infrastructure_state_key" {
  description = "S3 key containing the infrastructure Terraform state."
  type        = string
}

variable "project_name" {
  description = "Project name used for Kubernetes labels."
  type        = string
  default     = "uptime-kuma"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner label applied to Kubernetes resources."
  type        = string
  default     = "ofek"
}

variable "storage_class_name" {
  description = "Name of the Kubernetes StorageClass."
  type        = string
  default     = "gp3"
}

variable "storage_class_reclaim_policy" {
  description = "Reclaim policy used by the StorageClass."
  type        = string
  default     = "Delete"

  validation {
    condition = contains(
      ["Delete", "Retain"],
      var.storage_class_reclaim_policy
    )

    error_message = "storage_class_reclaim_policy must be Delete or Retain."
  }
}

variable "storage_class_is_default" {
  description = "Whether the StorageClass is the cluster default."
  type        = bool
  default     = false
}