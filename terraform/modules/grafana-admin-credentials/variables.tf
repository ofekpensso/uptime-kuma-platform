variable "secret_name" {
  description = "AWS Secrets Manager secret containing Grafana admin credentials."
  type        = string
}

variable "admin_user" {
  description = "Grafana administrator username."
  type        = string
  default     = "admin"
}

variable "password_length" {
  description = "Length of the generated Grafana administrator password."
  type        = number
  default     = 32

  validation {
    condition     = var.password_length >= 20
    error_message = "password_length must be at least 20 characters."
  }
}

variable "password_version" {
  description = "Increment this value intentionally to rotate the Grafana password."
  type        = number
  default     = 1

  validation {
    condition     = var.password_version >= 1
    error_message = "password_version must be at least 1."
  }
}

variable "tags" {
  description = "Tags applied to supported AWS resources."
  type        = map(string)
  default     = {}
}