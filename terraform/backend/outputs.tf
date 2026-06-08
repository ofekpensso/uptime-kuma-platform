output "state_bucket_name" {
  description = "Name of the S3 bucket used for Terraform remote state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket used for Terraform remote state."
  value       = aws_s3_bucket.terraform_state.arn
}

output "aws_region" {
  description = "AWS region where the backend resources were created."
  value       = var.aws_region
}

output "backend_key_example" {
  description = "Example backend key for the backend root module state."
  value       = "${var.project_name}/backend/terraform.tfstate"
}