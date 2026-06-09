locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "vpc"
    }
  )
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-igw"
    }
  )
}

# -------------------------
# Public Subnets
# -------------------------

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-${var.availability_zones[count.index]}"

      # Required for Kubernetes AWS Load Balancer Controller
      "kubernetes.io/role/elb" = "1"
    }
  )
}

# -------------------------
# Private App Subnets
# EKS worker nodes will live here
# -------------------------

resource "aws_subnet" "private_app" {
  count = length(var.private_app_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-app-${var.availability_zones[count.index]}"

      # Required for internal Kubernetes load balancers
      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}

# -------------------------
# Private Data Subnets
# RDS will live here
# -------------------------

resource "aws_subnet" "private_data" {
  count = length(var.private_data_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_data_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-data-${var.availability_zones[count.index]}"
    }
  )
}

# -------------------------
# Public Route Table
# Internet-facing traffic
# -------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-rt"
    }
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# -------------------------
# NAT Gateway
# Cost-optimized: single NAT Gateway in the first public subnet
# -------------------------

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-eip"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-gw"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# -------------------------
# Private App Route Table
# EKS nodes need outbound access through NAT
# -------------------------

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-app-rt"
    }
  )
}

resource "aws_route" "private_app_nat_access" {
  count = var.enable_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private_app" {
  count = length(aws_subnet.private_app)

  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app.id
}

# -------------------------
# Private Data Route Table
# Isolated data subnets: no internet route
# -------------------------

resource "aws_route_table" "private_data" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-data-rt"
    }
  )
}

resource "aws_route_table_association" "private_data" {
  count = length(aws_subnet.private_data)

  subnet_id      = aws_subnet.private_data[count.index].id
  route_table_id = aws_route_table.private_data.id
}

data "aws_region" "current" {}