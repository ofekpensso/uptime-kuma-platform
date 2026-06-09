locals {
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

  enable_nat_gateway         = var.enable_nat_gateway
  enable_s3_gateway_endpoint = var.enable_s3_gateway_endpoint

  tags = local.common_tags
}


module "security_groups" {
  source = "../../modules/security-groups"

  project_name = var.project_name
  environment  = var.environment

  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block

  app_port      = var.app_port
  database_port = var.database_port

  allowed_http_cidr_blocks  = var.allowed_http_cidr_blocks
  allowed_https_cidr_blocks = var.allowed_https_cidr_blocks

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