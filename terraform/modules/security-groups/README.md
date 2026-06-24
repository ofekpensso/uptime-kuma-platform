# Security Groups Module

This module creates the main security groups for the Uptime Kuma AWS DevOps project.

## Security Groups

### ALB Security Group

Allows public HTTP/HTTPS traffic from the internet to the Application Load Balancer.

Inbound:

- TCP 80 from allowed HTTP CIDRs
- TCP 443 from allowed HTTPS CIDRs

Outbound:

- All traffic

### EKS Security Group

Used by EKS worker nodes and Kubernetes workloads.

Inbound:

- All traffic from itself
- Application traffic from ALB Security Group

Outbound:

- All traffic

### RDS Security Group

Used by private PostgreSQL RDS.

Inbound:

- PostgreSQL from EKS Security Group

Outbound:

- All traffic

### VPC Endpoints Security Group

Used by Interface VPC Endpoints such as ECR API, ECR DKR, and Secrets Manager.

Inbound:

- HTTPS 443 from EKS Security Group

Outbound:

- All traffic

## Design

The security model follows a least-privilege approach:

Internet -> ALB -> EKS 

The database is never exposed publicly.

## Lab vs Production

This lab keeps outbound rules open for simplicity and compatibility.

In production, outbound rules can be restricted further based on application requirements.