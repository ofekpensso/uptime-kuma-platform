variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string

  validation {
    condition     = length(trimspace(var.cluster_name)) > 0
    error_message = "cluster_name must not be empty."
  }
}

variable "namespace" {
  description = "Kubernetes namespace where External Secrets Operator runs."
  type        = string
  default     = "external-secrets"
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount used by External Secrets Operator."
  type        = string
  default     = "external-secrets"
}

variable "role_name" {
  description = "Name of the IAM role assigned to External Secrets Operator."
  type        = string

  validation {
    condition     = length(trimspace(var.role_name)) > 0
    error_message = "role_name must not be empty."
  }
}

variable "secret_arns" {
  description = "Secrets Manager ARNs that External Secrets Operator is allowed to read."
  type        = list(string)

  validation {
    condition     = length(var.secret_arns) > 0
    error_message = "secret_arns must contain at least one Secrets Manager ARN."
  }
}

variable "tags" {
  description = "Tags applied to the IAM role."
  type        = map(string)
  default     = {}
}