locals {
  common_labels = {
    project     = var.project_name
    environment = var.environment
    managed-by  = "terraform"
    owner       = var.owner
  }
}

module "gp3_storage_class" {
  source = "../../modules/storage-class"

  name                   = var.storage_class_name
  storage_provisioner    = "ebs.csi.aws.com"
  volume_type            = "gp3"
  encrypted              = true
  file_system_type       = "ext4"
  reclaim_policy         = var.storage_class_reclaim_policy
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
  is_default_class       = var.storage_class_is_default

  labels = local.common_labels
}