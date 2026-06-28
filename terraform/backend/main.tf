locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    Component   = "terraform-backend"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name

  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-terraform-state"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "expire-old-noncurrent-state-versions"
    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }

  depends_on = [aws_s3_bucket_versioning.terraform_state]
}

module "ses_alerting" {
  source = "../modules/ses-alerting"

  aws_region    = var.aws_region
  sender_email  = var.alertmanager_email
  iam_user_name = "${var.project_name}-${var.environment}-alertmanager-ses-smtp"
  secret_name   = "${var.project_name}/${var.environment}/alertmanager-ses-smtp"

  tags = merge(
    local.common_tags,
    {
      Component = "ses-alerting"
    }
  )
}

module "grafana_admin_credentials" {
  source = "../modules/grafana-admin-credentials"

  secret_name      = "${var.project_name}/${var.environment}/grafana-admin-credentials"
  admin_user       = "admin"
  password_length  = 32
  password_version = 1

  tags = merge(
    local.common_tags,
    {
      Component = "grafana-admin-credentials"
    }
  )
}