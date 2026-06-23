data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "AllowEksPodIdentity"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-namespace"
      values   = [var.namespace]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-service-account"
      values   = [var.service_account_name]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  description        = "Allows External Secrets Operator to read approved secrets."
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "secrets_manager_read" {
  statement {
    sid    = "ReadApprovedSecrets"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]

    resources = var.secret_arns
  }
}

resource "aws_iam_policy" "secrets_manager_read" {
  name        = "${var.role_name}-secrets-reader"
  description = "Allows External Secrets Operator to read approved Secrets Manager secrets."
  policy      = data.aws_iam_policy_document.secrets_manager_read.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "secrets_manager_read" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.secrets_manager_read.arn
}

resource "aws_eks_pod_identity_association" "this" {
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = var.service_account_name
  role_arn        = aws_iam_role.this.arn
}