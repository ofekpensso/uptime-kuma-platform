# VPC Module

This module creates a cost-optimized AWS VPC for the Uptime Kuma DevOps project.

## Resources

- VPC
- Internet Gateway
- Public subnets
- Private application subnets
- Private data subnets
- Public route table
- Private app route table
- Private data route table
- Single NAT Gateway
- S3 Gateway VPC Endpoint

## Design

The VPC is designed for a lab environment with production-like structure and cost optimization.

### Public Subnets

Used for:

- Application Load Balancer
- NAT Gateway

### Private App Subnets

Used for:

- EKS worker nodes
- Kubernetes workloads

### Private Data Subnets

Used for:

- RDS PostgreSQL

These subnets are isolated and do not have a direct internet route.

## Cost Optimization

This module creates a single NAT Gateway instead of one NAT Gateway per AZ.

In production, one NAT Gateway per AZ would be preferred for high availability.