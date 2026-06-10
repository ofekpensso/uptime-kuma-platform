variable "github_owner" {
  description = "GitHub organization or username that owns the repository."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name allowed to assume this role."
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to assume this role."
  type        = string
  default     = "main"
}

variable "role_name" {
  description = "IAM role name for GitHub Actions."
  type        = string
}

variable "policy_name" {
  description = "IAM policy name for GitHub Actions ECR push permissions."
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository GitHub Actions can push to."
  type        = string
}

variable "tags" {
  description = "Tags to apply to IAM resources."
  type        = map(string)
  default     = {}
}