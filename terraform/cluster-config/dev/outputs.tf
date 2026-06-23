output "eks_cluster_name" {
  description = "Name of the configured EKS cluster."
  value       = data.aws_eks_cluster.this.name
}

output "storage_class_name" {
  description = "Name of the managed StorageClass."
  value       = module.gp3_storage_class.name
}

output "storage_class_provisioner" {
  description = "Provisioner used by the StorageClass."
  value       = module.gp3_storage_class.storage_provisioner
}

output "storage_class_reclaim_policy" {
  description = "Reclaim policy used by the StorageClass."
  value       = module.gp3_storage_class.reclaim_policy
}

output "storage_class_volume_binding_mode" {
  description = "Volume binding mode used by the StorageClass."
  value       = module.gp3_storage_class.volume_binding_mode
}

output "argocd_release_name" {
  description = "Name of the Argo CD Helm release."
  value       = module.argocd.release_name
}

output "argocd_namespace" {
  description = "Namespace where Argo CD is installed."
  value       = module.argocd.namespace
}

output "argocd_chart_version" {
  description = "Installed Argo CD Helm chart version."
  value       = module.argocd.chart_version
}

output "argocd_status" {
  description = "Current status of the Argo CD Helm release."
  value       = module.argocd.status
}

output "argocd_server_service_type" {
  description = "Kubernetes Service type used by the Argo CD server."
  value       = module.argocd.server_service_type
}