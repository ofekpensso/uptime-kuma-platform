variable "name" {
  description = "Name of the Secrets Manager secret."
  type        = string
}

variable "description" {
  description = "Description of the secret."
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days before AWS Secrets Manager deletes the secret."
  type        = number
  default     = 7
}

variable "password_length" {
  description = "Length of the generated password."
  type        = number
  default     = 24
}

variable "tags" {
  description = "Tags to apply to the secret."
  type        = map(string)
  default     = {}
}