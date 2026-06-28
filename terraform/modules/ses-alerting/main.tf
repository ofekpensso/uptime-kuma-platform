data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

locals {
  ses_identity_arn = format(
    "arn:%s:ses:%s:%s:identity/%s",
    data.aws_partition.current.partition,
    var.aws_region,
    data.aws_caller_identity.current.account_id,
    var.sender_email
  )

  smtp_host = "email-smtp.${var.aws_region}.amazonaws.com"
}

resource "aws_sesv2_email_identity" "this" {
  email_identity = var.sender_email

  tags = merge(
    var.tags,
    {
      Name = var.sender_email
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_user" "smtp" {
  name          = var.iam_user_name
  path          = "/uptime-kuma/"
  force_destroy = false

  tags = merge(
    var.tags,
    {
      Name = var.iam_user_name
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_user_policy" "smtp" {
  name = "${var.iam_user_name}-send-email"
  user = aws_iam_user.smtp.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowEmailFromVerifiedIdentity"
        Effect = "Allow"

        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]

        Resource = local.ses_identity_arn

        Condition = {
          StringEquals = {
            "ses:FromAddress" = var.sender_email
          }
        }
      }
    ]
  })
}

resource "aws_iam_access_key" "smtp" {
  user = aws_iam_user.smtp.name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret" "smtp" {
  name        = var.secret_name
  description = "Amazon SES SMTP credentials for Alertmanager"

  # Enables immediate recreation only after an intentional full teardown.
  recovery_window_in_days = 0

  tags = merge(
    var.tags,
    {
      Name = var.secret_name
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "smtp" {
  secret_id = aws_secretsmanager_secret.smtp.id

  secret_string = jsonencode({
    smtp_username = aws_iam_access_key.smtp.id
    smtp_password = aws_iam_access_key.smtp.ses_smtp_password_v4
    smtp_host     = local.smtp_host
    smtp_port     = tostring(var.smtp_port)
    from_address  = var.sender_email
  })
}