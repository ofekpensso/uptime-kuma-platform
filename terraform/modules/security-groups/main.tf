locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "security-groups"
    }
  )
}

# =========================================================
# ALB Security Group
# Public entry point into the application
# =========================================================

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for public Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP from the internet"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  cidr_ipv4 = var.allowed_http_cidr_blocks[0]
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTPS from the internet"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  cidr_ipv4 = var.allowed_https_cidr_blocks[0]
}

resource "aws_vpc_security_group_egress_rule" "alb_all_outbound" {
  security_group_id = aws_security_group.alb.id

  description = "Allow all outbound traffic from ALB"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# =========================================================
# EKS Security Group
# Used by EKS worker nodes / Kubernetes workloads
# =========================================================

resource "aws_security_group" "eks" {
  name        = "${local.name_prefix}-eks-sg"
  description = "Security group for EKS worker nodes and Kubernetes workloads"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-eks-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "eks_self_all" {
  security_group_id = aws_security_group.eks.id

  description                  = "Allow all internal traffic between EKS nodes and pods"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks.id
}

resource "aws_vpc_security_group_ingress_rule" "eks_from_alb_app" {
  security_group_id = aws_security_group.eks.id

  description                  = "Allow application traffic from ALB to EKS workloads"
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "eks_all_outbound" {
  security_group_id = aws_security_group.eks.id

  description = "Allow all outbound traffic from EKS"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# =========================================================
# RDS Security Group
# Database is private and only accessible from EKS
# =========================================================

resource "aws_security_group" "rds" {
  name        = "${local.name_prefix}-rds-sg"
  description = "Security group for private RDS PostgreSQL"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_eks_nodes" {
  security_group_id = aws_security_group.rds.id

  description                  = "Allow MariaDB traffic from EKS worker nodes"
  from_port                    = var.rds_port
  to_port                      = var.rds_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.eks_node_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "rds_all_outbound" {
  security_group_id = aws_security_group.rds.id

  description = "Allow all outbound traffic from RDS"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# =========================================================
# VPC Endpoints Security Group
# Used by Interface Endpoints such as ECR and Secrets Manager
# =========================================================

resource "aws_security_group" "vpc_endpoints" {
  name        = "${local.name_prefix}-vpc-endpoints-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc-endpoints-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "vpc_endpoints_https_from_eks" {
  security_group_id = aws_security_group.vpc_endpoints.id

  description                  = "Allow HTTPS from EKS to VPC Interface Endpoints"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.eks.id
}

resource "aws_vpc_security_group_egress_rule" "vpc_endpoints_all_outbound" {
  security_group_id = aws_security_group.vpc_endpoints.id

  description = "Allow all outbound traffic from VPC Endpoints"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}