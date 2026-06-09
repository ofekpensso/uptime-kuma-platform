# EKS Module

This module creates an Amazon EKS cluster for the Uptime Kuma DevOps project.

It is implemented as a thin internal wrapper around the community-maintained
`terraform-aws-modules/eks/aws` module.

## Resources

- EKS Cluster
- EKS Managed Node Group
- EKS Addons
  - vpc-cni
  - coredns
  - kube-proxy
  - aws-ebs-csi-driver
- OIDC Provider for IRSA
- EKS security groups and IAM resources managed by the upstream module

## Design

Worker nodes are deployed in private application subnets.

Public traffic should enter through an Application Load Balancer and then reach
Kubernetes workloads through Ingress and Service resources.

## Cost Optimization

The default lab setup uses a single On-Demand managed node group:

- min size: 1
- desired size: 1
- max size: 2

Spot node group support is prepared but disabled by default.

## Production Improvements

- Restrict public API endpoint to trusted CIDRs or use private-only endpoint
- Add dedicated system and application node groups
- Add Cluster Autoscaler or Karpenter
- Enable Network Policies
- Add Spot nodes for non-critical workloads
- Use multiple node groups across multiple AZs