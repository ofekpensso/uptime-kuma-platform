locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

  public_subnet_cidrs       = var.public_subnet_cidrs
  private_app_subnet_cidrs  = var.private_app_subnet_cidrs
  private_data_subnet_cidrs = var.private_data_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway

  tags = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name        = var.ecr_repository_name
  image_tag_mutability   = var.ecr_image_tag_mutability
  scan_on_push           = var.ecr_scan_on_push
  force_delete           = var.ecr_force_delete
  keep_last_images       = var.ecr_keep_last_images
  lifecycle_tag_prefixes = var.ecr_lifecycle_tag_prefixes

  tags = local.common_tags
}

module "github_oidc" {
  source = "../../modules/github-oidc"

  github_owner      = var.github_owner
  github_repository = var.github_repository
  github_branch     = var.github_branch

  role_name   = "${local.name_prefix}-github-actions-ecr-role"
  policy_name = "${local.name_prefix}-github-actions-ecr-policy"

  ecr_repository_arn = module.ecr.repository_arn

  tags = local.common_tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = var.project_name
  environment  = var.environment

  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block

  app_port                   = var.app_port
  eks_node_security_group_id = module.eks.node_security_group_id

  allowed_http_cidr_blocks  = var.allowed_http_cidr_blocks
  allowed_https_cidr_blocks = var.allowed_https_cidr_blocks

  tags = local.common_tags
}

module "vpc_endpoints" {
  source = "../../modules/vpc-endpoint"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_app_subnet_ids

  route_table_ids = [
    module.vpc.private_app_route_table_id,
    module.vpc.private_data_route_table_id
  ]

  security_group_ids = [
    module.security_groups.vpc_endpoints_security_group_id
  ]

  enable_s3_gateway_endpoint = var.enable_s3_gateway_endpoint
  enable_ecr_api_endpoint    = true
  enable_ecr_dkr_endpoint    = true

  private_dns_enabled = true

  tags = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  project_name = var.project_name
  environment  = var.environment

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_app_subnet_ids

  cluster_version = var.eks_cluster_version

  authentication_mode = var.eks_authentication_mode

  endpoint_public_access  = var.eks_endpoint_public_access
  endpoint_private_access = var.eks_endpoint_private_access

  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  node_instance_types = var.eks_node_instance_types
  node_capacity_type  = var.eks_node_capacity_type
  node_min_size       = var.eks_node_min_size
  node_desired_size   = var.eks_node_desired_size
  node_max_size       = var.eks_node_max_size
  node_disk_size      = var.eks_node_disk_size

  enable_spot_node_group = var.enable_spot_node_group
  spot_instance_types    = var.eks_spot_instance_types

  tags = local.common_tags
}

module "external_secrets_pod_identity" {
  source = "../../modules/external-secrets-pod-identity"

  cluster_name = module.eks.cluster_name

  namespace            = "external-secrets"
  service_account_name = "external-secrets"

  role_name = "${var.project_name}-${var.environment}-external-secrets-role"

  secret_arns = ["*"]
}

module "aws_load_balancer_controller_pod_identity" {
  source = "../../modules/aws-load-balancer-controller-pod-identity"

  cluster_name = module.eks.cluster_name

  namespace = (
    var.aws_load_balancer_controller_namespace
  )

  service_account_name = (
    var.aws_load_balancer_controller_service_account_name
  )

  role_name = (
    "${local.name_prefix}-aws-load-balancer-controller-role"
  )

  policy_name = (
    "${local.name_prefix}-aws-load-balancer-controller-policy"
  )

  tags = local.common_tags
}