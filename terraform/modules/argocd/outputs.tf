output "release_name" {
  description = "Name of the Argo CD Helm release."
  value       = helm_release.this.name
}

output "namespace" {
  description = "Namespace where Argo CD is installed."
  value       = var.namespace
}

output "chart_name" {
  description = "Name of the installed Helm chart."
  value       = var.chart_name
}

output "chart_version" {
  description = "Version of the installed Argo CD Helm chart."
  value       = var.chart_version
}

output "status" {
  description = "Current status of the Argo CD Helm release."
  value       = helm_release.this.status
}

output "server_service_type" {
  description = "Kubernetes Service type used by the Argo CD server."
  value       = var.server_service_type
}

output "namespace_managed_by_terraform" {
  description = "Whether the namespace is directly managed by Terraform."
  value       = var.manage_namespace
}

output "bootstrap_release_name" {
  description = "Name of the Argo CD bootstrap Helm release."
  value       = try(helm_release.bootstrap[0].name, null)
}