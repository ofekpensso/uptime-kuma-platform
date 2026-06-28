variable "aws_region" {
  description = "AWS region in which SES is configured."
  type        = string
}

variable "sender_email" {
  description = "Verified SES email identity used as the Alertmanager sender."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.sender_email))
    error_message = "sender_email must be a valid email address."
  }
}

variable "iam_user_name" {
  description = "IAM user name used for SES SMTP authentication."
  type        = string
}

variable "secret_name" {
  description = "AWS Secrets Manager secret containing the SES SMTP settings."
  type        = string
}

variable "smtp_port" {
  description = "SES SMTP STARTTLS port."
  type        = number
  default     = 587
}

variable "tags" {
  description = "Tags to apply to supported resources."
  type        = map(string)
  default     = {}
}