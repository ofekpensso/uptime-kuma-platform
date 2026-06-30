locals {
  normalized_record_names = [
    for record_name in var.managed_record_names :
    trimsuffix(
      lower(trimspace(record_name)),
      "."
    )
  ]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "AllowEksPodIdentity"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type = "Service"

      identifiers = [
        "pods.eks.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-namespace"

      values = [
        var.namespace
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-service-account"

      values = [
        var.service_account_name
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  name        = var.role_name
  description = "Allows ExternalDNS to manage approved Route 53 DNS records through EKS Pod Identity."

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "route53" {
  statement {
    sid    = "ChangeApprovedDnsRecords"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    resources = [
      var.hosted_zone_arn
    ]

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "route53:ChangeResourceRecordSetsActions"

      values = [
        "CREATE",
        "UPSERT"
      ]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "route53:ChangeResourceRecordSetsRecordTypes"

      values = [
        "A",
        "AAAA",
        "TXT"
      ]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "route53:ChangeResourceRecordSetsNormalizedRecordNames"

      values = local.normalized_record_names
    }
  }

  statement {
    sid    = "ReadApprovedHostedZone"
    effect = "Allow"

    actions = [
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResources"
    ]

    resources = [
      var.hosted_zone_arn
    ]
  }

  statement {
    sid    = "ListHostedZones"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = "Allows ExternalDNS to manage approved records in one Route 53 hosted zone."

  policy = data.aws_iam_policy_document.route53.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}