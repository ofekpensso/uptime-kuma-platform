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

variable "argocd_release_name" {
  description = "Name of the Argo CD Helm release."
  type        = string
  default     = "argocd"

  validation {
    condition     = length(trimspace(var.argocd_release_name)) > 0
    error_message = "argocd_release_name must not be empty."
  }
}

variable "argocd_namespace" {
  description = "Kubernetes namespace where Argo CD is installed."
  type        = string
  default     = "argocd"

  validation {
    condition     = length(trimspace(var.argocd_namespace)) > 0
    error_message = "argocd_namespace must not be empty."
  }
}

variable "argocd_chart_version" {
  description = "Pinned version of the Argo CD Helm chart."
  type        = string
  default     = "9.5.9"

  validation {
    condition     = length(trimspace(var.argocd_chart_version)) > 0
    error_message = "argocd_chart_version must not be empty."
  }
}

variable "argocd_manage_namespace" {
  description = "Whether Terraform should create and manage the Argo CD namespace."
  type        = bool
  default     = true
}

variable "argocd_server_service_type" {
  description = "Kubernetes Service type used by the Argo CD server."
  type        = string
  default     = "ClusterIP"

  validation {
    condition = contains(
      ["ClusterIP", "NodePort", "LoadBalancer"],
      var.argocd_server_service_type
    )

    error_message = "argocd_server_service_type must be ClusterIP, NodePort, or LoadBalancer."
  }
}

variable "argocd_install_crds" {
  description = "Whether the Argo CD Helm chart should install its CRDs."
  type        = bool
  default     = true
}

variable "argocd_keep_crds" {
  description = "Whether Argo CD CRDs should remain after removing the Helm release."
  type        = bool
  default     = false
}

variable "argocd_controller_replicas" {
  description = "Number of Argo CD application controller replicas."
  type        = number
  default     = 1

  validation {
    condition     = var.argocd_controller_replicas >= 1
    error_message = "argocd_controller_replicas must be at least 1."
  }
}

variable "argocd_server_replicas" {
  description = "Number of Argo CD server replicas."
  type        = number
  default     = 1

  validation {
    condition     = var.argocd_server_replicas >= 1
    error_message = "argocd_server_replicas must be at least 1."
  }
}

variable "argocd_repo_server_replicas" {
  description = "Number of Argo CD repository server replicas."
  type        = number
  default     = 1

  validation {
    condition     = var.argocd_repo_server_replicas >= 1
    error_message = "argocd_repo_server_replicas must be at least 1."
  }
}

variable "argocd_application_set_replicas" {
  description = "Number of Argo CD ApplicationSet controller replicas."
  type        = number
  default     = 1

  validation {
    condition     = var.argocd_application_set_replicas >= 1
    error_message = "argocd_application_set_replicas must be at least 1."
  }
}

variable "argocd_redis_ha_enabled" {
  description = "Whether the Redis HA subchart should be enabled."
  type        = bool
  default     = false
}


variable "argocd_bootstrap_enabled" {
  description = "Whether to install the Argo CD root bootstrap application."
  type        = bool
}

variable "argocd_bootstrap_release_name" {
  description = "Helm release name for Argo CD bootstrap applications."
  type        = string
}

variable "argocd_bootstrap_chart_version" {
  description = "Pinned version of the argocd-apps Helm chart."
  type        = string
}