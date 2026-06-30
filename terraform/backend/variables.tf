variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "uptime-kuma"
}

variable "environment" {
  description = "Environment name for backend resources."
  type        = string
  default     = "shared"
}

variable "aws_region" {
  description = "AWS region for the Terraform backend resources."
  type        = string
  default     = "us-east-1"
}

variable "owner" {
  description = "Owner of the resources."
  type        = string
  default     = "ofek"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days to retain noncurrent Terraform state versions."
  type        = number
  default     = 90
}

variable "alertmanager_email" {
  description = "Email address verified in SES and used by Alertmanager."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alertmanager_email))
    error_message = "alertmanager_email must be a valid email address."
  }
}

variable "domain_name" {
  description = "Public root domain managed by Route 53."
  type        = string

  validation {
    condition = (
      length(trimspace(var.domain_name)) > 0 &&
      strcontains(var.domain_name, ".")
    )

    error_message = "domain_name must be a valid public domain, for example example.com."
  }
}

variable "application_subdomain" {
  description = "Subdomain used by the Uptime Kuma application."
  type        = string
  default     = "uptime"

  validation {
    condition = can(
      regex(
        "^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$",
        lower(trimspace(var.application_subdomain))
      )
    )

    error_message = "application_subdomain must be a valid DNS label such as uptime."
  }
}