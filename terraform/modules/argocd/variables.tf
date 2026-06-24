variable "release_name" {
  description = "Name of the Argo CD Helm release."
  type        = string
  default     = "argocd"

  validation {
    condition     = length(trimspace(var.release_name)) > 0
    error_message = "release_name must not be empty."
  }
}

variable "namespace" {
  description = "Kubernetes namespace where Argo CD is installed."
  type        = string
  default     = "argocd"

  validation {
    condition     = length(trimspace(var.namespace)) > 0
    error_message = "namespace must not be empty."
  }
}

variable "manage_namespace" {
  description = "Whether Terraform should create and manage the Argo CD namespace."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels applied to the namespace and Argo CD resources."
  type        = map(string)
  default     = {}
}

variable "chart_repository" {
  description = "Helm repository containing the Argo CD chart."
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "chart_name" {
  description = "Name of the Argo CD Helm chart."
  type        = string
  default     = "argo-cd"
}

variable "chart_version" {
  description = "Pinned version of the Argo CD Helm chart."
  type        = string
  default     = "9.5.9"
}

variable "server_service_type" {
  description = "Kubernetes Service type used by the Argo CD server."
  type        = string
  default     = "ClusterIP"

  validation {
    condition = contains(
      ["ClusterIP", "NodePort", "LoadBalancer"],
      var.server_service_type
    )

    error_message = "server_service_type must be ClusterIP, NodePort, or LoadBalancer."
  }
}

variable "install_crds" {
  description = "Whether the Argo CD Helm chart should install its CRDs."
  type        = bool
  default     = true
}

variable "keep_crds" {
  description = "Whether Argo CD CRDs should remain after uninstalling the Helm release."
  type        = bool
  default     = true
}

variable "controller_replicas" {
  description = "Number of Argo CD application controller replicas."
  type        = number
  default     = 1

  validation {
    condition     = var.controller_replicas >= 1
    error_message = "controller_replicas must be at least 1."
  }
}

variable "server_replicas" {
  description = "Number of Argo CD server replicas."
  type        = number
  default     = 1

  validation {
    condition     = var.server_replicas >= 1
    error_message = "server_replicas must be at least 1."
  }
}

variable "repo_server_replicas" {
  description = "Number of Argo CD repository server replicas."
  type        = number
  default     = 1

  validation {
    condition     = var.repo_server_replicas >= 1
    error_message = "repo_server_replicas must be at least 1."
  }
}

variable "application_set_replicas" {
  description = "Number of Argo CD ApplicationSet controller replicas."
  type        = number
  default     = 1

  validation {
    condition     = var.application_set_replicas >= 1
    error_message = "application_set_replicas must be at least 1."
  }
}

variable "redis_ha_enabled" {
  description = "Whether the Redis HA subchart should be enabled."
  type        = bool
  default     = false
}

variable "wait" {
  description = "Whether Terraform should wait until the Helm release is ready."
  type        = bool
  default     = true
}

variable "timeout_seconds" {
  description = "Maximum time in seconds to wait for Helm operations."
  type        = number
  default     = 600

  validation {
    condition     = var.timeout_seconds > 0
    error_message = "timeout_seconds must be greater than zero."
  }
}

variable "cleanup_on_fail" {
  description = "Whether Helm should remove newly created resources after a failed installation."
  type        = bool
  default     = true
}

variable "max_history" {
  description = "Maximum number of Helm release revisions to retain."
  type        = number
  default     = 5

  validation {
    condition     = var.max_history >= 1
    error_message = "max_history must be at least 1."
  }
}

variable "additional_values" {
  description = "Additional raw YAML values merged after the module's base Argo CD values."
  type        = list(string)
  default     = []
}

variable "bootstrap_enabled" {
  description = "Whether to install the Argo CD bootstrap applications Helm release."
  type        = bool
  default     = false
}

variable "bootstrap_release_name" {
  description = "Helm release name for the Argo CD bootstrap applications."
  type        = string
  default     = "argocd-bootstrap"
}

variable "bootstrap_chart_repository" {
  description = "Helm repository containing the argocd-apps chart."
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "bootstrap_chart_name" {
  description = "Helm chart used to create the bootstrap Argo CD Applications."
  type        = string
  default     = "argocd-apps"
}

variable "bootstrap_chart_version" {
  description = "Pinned version of the argocd-apps Helm chart."
  type        = string
  default     = "2.0.5"
}

variable "bootstrap_values" {
  description = "Additional values files rendered as strings for the argocd-apps release."
  type        = list(string)
  default     = []
}