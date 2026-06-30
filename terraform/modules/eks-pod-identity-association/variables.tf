variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string

  validation {
    condition     = length(trimspace(var.cluster_name)) > 0
    error_message = "cluster_name must not be empty."
  }
}

variable "namespace" {
  description = "Kubernetes namespace containing the ServiceAccount."
  type        = string

  validation {
    condition = can(
      regex(
        "^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$",
        var.namespace
      )
    )

    error_message = "namespace must be a valid Kubernetes namespace name."
  }
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount associated with the IAM role."
  type        = string

  validation {
    condition = can(
      regex(
        "^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$",
        var.service_account_name
      )
    )

    error_message = "service_account_name must be a valid Kubernetes ServiceAccount name."
  }
}

variable "role_arn" {
  description = "ARN of the IAM role assigned through EKS Pod Identity."
  type        = string

  validation {
    condition = can(
      regex(
        "^arn:aws:iam::[0-9]{12}:role/.+$",
        var.role_arn
      )
    )

    error_message = "role_arn must be a valid IAM role ARN."
  }
}

variable "tags" {
  description = "Tags applied to the EKS Pod Identity association."
  type        = map(string)
  default     = {}
}