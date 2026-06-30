variable "domain_name" {
  description = "Public root domain managed by the Route 53 hosted zone."
  type        = string

  validation {
    condition = (
      length(trimspace(var.domain_name)) > 0 &&
      strcontains(var.domain_name, ".")
    )

    error_message = "domain_name must be a valid public domain, for example example.com."
  }
}

variable "certificate_domain_name" {
  description = "Fully qualified domain name covered by the ACM certificate."
  type        = string

  validation {
    condition = (
      length(trimspace(var.certificate_domain_name)) > 0 &&
      strcontains(var.certificate_domain_name, ".")
    )

    error_message = "certificate_domain_name must be a fully qualified domain name."
  }
}

variable "validation_record_ttl" {
  description = "TTL in seconds for the ACM DNS validation record."
  type        = number
  default     = 300

  validation {
    condition     = var.validation_record_ttl >= 60
    error_message = "validation_record_ttl must be at least 60 seconds."
  }
}

variable "tags" {
  description = "Tags to apply to supported AWS resources."
  type        = map(string)
  default     = {}
}