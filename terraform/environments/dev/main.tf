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

  app_port                   = var.app_port
  rds_port                   = var.db_port
  eks_node_security_group_id = module.eks.node_security_group_id

  allowed_http_cidr_blocks  = var.allowed_http_cidr_blocks
  allowed_https_cidr_blocks = var.allowed_https_cidr_blocks

  tags = local.common_tags
}

module "rds_secret" {
  source = "../../modules/secrets-manager"

  name        = "${local.name_prefix}/rds/credentials"
  description = "RDS credentials for ${local.name_prefix}"

  recovery_window_in_days = 0

  tags = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  identifier = "${local.name_prefix}-mariadb"

  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage

  database_name = var.db_name
  username      = var.db_username
  password      = module.rds_secret.password
  port          = var.db_port

  subnet_ids             = module.vpc.private_data_subnet_ids
  vpc_security_group_ids = [module.security_groups.rds_security_group_id]

  multi_az                = var.db_multi_az
  publicly_accessible     = false
  backup_retention_period = var.db_backup_retention_period
  deletion_protection     = var.db_deletion_protection
  skip_final_snapshot     = true
  storage_encrypted       = true
  apply_immediately       = true

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = module.rds_secret.secret_id

  secret_string = jsonencode({
    engine   = var.db_engine
    host     = module.rds.db_instance_address
    port     = module.rds.db_instance_port
    dbname   = var.db_name
    username = var.db_username
    password = module.rds_secret.password
  })
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