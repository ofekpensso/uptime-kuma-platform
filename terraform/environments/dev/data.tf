data "aws_iam_role" "external_dns" {
  name = var.external_dns_iam_role_name
}