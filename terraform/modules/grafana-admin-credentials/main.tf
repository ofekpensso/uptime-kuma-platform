ephemeral "random_password" "this" {
  length           = var.password_length
  special          = true
  override_special = "!@#$%&*()-_=+"
}

resource "aws_secretsmanager_secret" "this" {
  name        = var.secret_name
  description = "Grafana administrator credentials"

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

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id

  secret_string_wo = jsonencode({
    "admin-user"     = var.admin_user
    "admin-password" = ephemeral.random_password.this.result
  })

  secret_string_wo_version = var.password_version
}