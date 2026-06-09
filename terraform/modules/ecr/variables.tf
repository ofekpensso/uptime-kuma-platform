variable "repository_name" {
  description = "Name of the ECR repository."
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting for the repository."
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Enable image scan on push."
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Delete the repository even if it contains images."
  type        = bool
  default     = true
}

variable "keep_last_images" {
  description = "Number of tagged images to keep."
  type        = number
  default     = 10
}

variable "lifecycle_tag_prefixes" {
  description = "List of tag prefixes that the lifecycle policy applies to."
  type        = list(string)
  default     = ["sha-"]
}

variable "tags" {
  description = "Tags to apply to ECR resources."
  type        = map(string)
  default     = {}
}