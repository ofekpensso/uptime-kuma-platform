output "name" {
  description = "Name of the Kubernetes StorageClass."
  value       = kubernetes_storage_class_v1.this.metadata[0].name
}

output "storage_provisioner" {
  description = "CSI provisioner used by the StorageClass."
  value       = kubernetes_storage_class_v1.this.storage_provisioner
}

output "reclaim_policy" {
  description = "Reclaim policy configured for the StorageClass."
  value       = kubernetes_storage_class_v1.this.reclaim_policy
}

output "volume_binding_mode" {
  description = "Volume binding mode configured for the StorageClass."
  value       = kubernetes_storage_class_v1.this.volume_binding_mode
}

output "allow_volume_expansion" {
  description = "Whether volume expansion is enabled."
  value       = kubernetes_storage_class_v1.this.allow_volume_expansion
}