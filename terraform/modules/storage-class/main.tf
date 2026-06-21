locals {
  default_class_annotations = var.is_default_class ? {
    "storageclass.kubernetes.io/is-default-class" = "true"
  } : {}

  annotations = merge(
    var.annotations,
    local.default_class_annotations
  )
}

resource "kubernetes_storage_class_v1" "this" {
  metadata {
    name        = var.name
    labels      = var.labels
    annotations = local.annotations
  }

  storage_provisioner = var.storage_provisioner

  parameters = {
    type                         = var.volume_type
    encrypted                    = tostring(var.encrypted)
    "csi.storage.k8s.io/fstype" = var.file_system_type
  }

  reclaim_policy         = var.reclaim_policy
  volume_binding_mode    = var.volume_binding_mode
  allow_volume_expansion = var.allow_volume_expansion
}