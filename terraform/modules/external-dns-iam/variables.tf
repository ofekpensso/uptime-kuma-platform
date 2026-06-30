variable "role_name" {
  description = "Name of the IAM role assumed by ExternalDNS through EKS Pod Identity."
  type        = string

  validation {
    condition     = length(trimspace(var.role_name)) > 0
    error_message = "role_name must not be empty."
  }
}

variable "policy_name" {
  description = "Name of the IAM policy that grants ExternalDNS access to Route 53."
  type        = string

  validation {
    condition     = length(trimspace(var.policy_name)) > 0
    error_message = "policy_name must not be empty."
  }
}

variable "hosted_zone_arn" {
  description = "ARN of the Route 53 hosted zone managed by ExternalDNS."
  type        = string

  validation {
    condition = can(
      regex(
        "^arn:aws:route53:::hostedzone/[A-Z0-9]+$",
        var.hosted_zone_arn
      )
    )

    error_message = "hosted_zone_arn must be a valid public Route 53 hosted zone ARN."
  }
}

variable "managed_record_names" {
  description = "DNS record names that ExternalDNS is allowed to create or update."
  type        = set(string)

  validation {
    condition = (
      length(var.managed_record_names) > 0 &&
      alltrue([
        for record_name in var.managed_record_names :
        length(trimspace(record_name)) > 0 &&
        strcontains(record_name, ".")
      ])
    )

    error_message = "managed_record_names must contain at least one valid fully qualified domain name."
  }
}

variable "namespace" {
  description = "Kubernetes namespace in which ExternalDNS runs."
  type        = string
  default     = "external-dns"

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
  description = "Kubernetes ServiceAccount used by ExternalDNS."
  type        = string
  default     = "external-dns"

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

variable "tags" {
  description = "Tags applied to ExternalDNS IAM resources."
  type        = map(string)
  default     = {}
}