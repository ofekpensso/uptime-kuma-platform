output "alb_security_group_id" {
  description = "ID of the ALB security group."
  value       = aws_security_group.alb.id
}

output "eks_security_group_id" {
  description = "ID of the EKS security group."
  value       = aws_security_group.eks.id
}

output "rds_security_group_id" {
  description = "ID of the RDS security group."
  value       = aws_security_group.rds.id
}

output "vpc_endpoints_security_group_id" {
  description = "ID of the VPC Endpoints security group."
  value       = aws_security_group.vpc_endpoints.id
}

output "alb_security_group_name" {
  description = "Name of the ALB security group."
  value       = aws_security_group.alb.name
}

output "eks_security_group_name" {
  description = "Name of the EKS security group."
  value       = aws_security_group.eks.name
}

output "rds_security_group_name" {
  description = "Name of the RDS security group."
  value       = aws_security_group.rds.name
}

output "vpc_endpoints_security_group_name" {
  description = "Name of the VPC Endpoints security group."
  value       = aws_security_group.vpc_endpoints.name
}