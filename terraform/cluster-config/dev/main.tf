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


module "argocd" {
  source = "../../modules/argocd"

  release_name     = var.argocd_release_name
  namespace        = var.argocd_namespace
  manage_namespace = var.argocd_manage_namespace

  chart_version       = var.argocd_chart_version
  server_service_type = var.argocd_server_service_type

  install_crds = var.argocd_install_crds
  keep_crds    = var.argocd_keep_crds

  controller_replicas      = var.argocd_controller_replicas
  server_replicas          = var.argocd_server_replicas
  repo_server_replicas     = var.argocd_repo_server_replicas
  application_set_replicas = var.argocd_application_set_replicas
  redis_ha_enabled         = var.argocd_redis_ha_enabled

  labels = local.common_labels

  bootstrap_enabled       = var.argocd_bootstrap_enabled
  bootstrap_release_name  = var.argocd_bootstrap_release_name
  bootstrap_chart_version = var.argocd_bootstrap_chart_version

  bootstrap_values = [
    file("${path.root}/../../../gitops/bootstrap/argocd-apps-values.yaml")
  ]
}