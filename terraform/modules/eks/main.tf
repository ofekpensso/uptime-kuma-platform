locals {
  name_prefix  = "${var.project_name}-${var.environment}"
  cluster_name = "${local.name_prefix}-eks"

  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "eks"
    }
  )

  eks_managed_node_groups = merge(
    {
      default_on_demand = {
        name = "${local.name_prefix}-od"

        capacity_type  = var.node_capacity_type
        instance_types = var.node_instance_types

        min_size     = var.node_min_size
        desired_size = var.node_desired_size
        max_size     = var.node_max_size

        disk_size = var.node_disk_size

        labels = {
          role      = "general"
          lifecycle = lower(var.node_capacity_type)
        }

        tags = merge(
          local.common_tags,
          {
            Name = "${local.name_prefix}-on-demand-node-group"
          }
        )
      }
    },
    var.enable_spot_node_group ? {
      spot = {
        name = "${local.name_prefix}-spot"

        capacity_type  = "SPOT"
        instance_types = var.spot_instance_types

        min_size     = 0
        desired_size = 0
        max_size     = 2

        disk_size = var.node_disk_size

        labels = {
          role      = "general"
          lifecycle = "spot"
        }

        taints = {
          spot = {
            key    = "lifecycle"
            value  = "spot"
            effect = "NO_SCHEDULE"
          }
        }

        tags = merge(
          local.common_tags,
          {
            Name = "${local.name_prefix}-spot-node-group"
          }
        )
      }
    } : {}
  )
}

data "aws_iam_policy_document" "ebs_csi_pod_identity_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "ebs_csi_driver" {
  name = "${local.name_prefix}-ebs-csi-driver-role"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_pod_identity_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ebs-csi-driver-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.20.0"

  name               = local.cluster_name
  kubernetes_version = var.cluster_version

  authentication_mode = var.authentication_mode

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access

  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  addons = {
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }

    kube-proxy = {
      most_recent = true
    }

    coredns = {
      most_recent = true
    }

    eks-pod-identity-agent = {
      most_recent = true
    }

    aws-ebs-csi-driver = {
      most_recent = true

      pod_identity_association = [{
        role_arn        = aws_iam_role.ebs_csi_driver.arn
        service_account = "ebs-csi-controller-sa"
      }]

      depends_on = [
        aws_iam_role_policy_attachment.ebs_csi_driver
      ]
    }
  }

  eks_managed_node_groups = local.eks_managed_node_groups

  tags = local.common_tags
}