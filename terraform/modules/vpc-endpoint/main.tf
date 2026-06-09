data "aws_region" "current" {}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# -----------------------------------------------------------------------------
# S3 Gateway VPC Endpoint
# Used by private subnets to access S3 privately.
# Also required for ECR image layer downloads.
# -----------------------------------------------------------------------------

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_gateway_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.route_table_ids

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-s3-gateway-endpoint"
    }
  )
}

# -----------------------------------------------------------------------------
# ECR API Interface VPC Endpoint
# Used for ECR API calls such as authentication and image metadata.
# -----------------------------------------------------------------------------

resource "aws_vpc_endpoint" "ecr_api" {
  count = var.enable_ecr_api_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = var.private_dns_enabled

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-ecr-api-endpoint"
    }
  )
}

# -----------------------------------------------------------------------------
# ECR Docker Interface VPC Endpoint
# Used by Docker/container runtime to pull images from ECR.
# -----------------------------------------------------------------------------

resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.enable_ecr_dkr_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = var.private_dns_enabled

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-ecr-dkr-endpoint"
    }
  )
}