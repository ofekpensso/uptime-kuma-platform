locals {
  base_values = {
    global = {
      additionalLabels = var.labels
    }

    crds = {
      install = var.install_crds
      keep    = var.keep_crds
    }

    controller = {
      replicas = var.controller_replicas
    }

    server = {
      replicas = var.server_replicas

      service = {
        type = var.server_service_type
      }
    }

    repoServer = {
      replicas = var.repo_server_replicas
    }

    applicationSet = {
      replicas = var.application_set_replicas
    }

    "redis-ha" = {
      enabled = var.redis_ha_enabled
    }
  }
}

resource "kubernetes_namespace_v1" "this" {
  count = var.manage_namespace ? 1 : 0

  metadata {
    name   = var.namespace
    labels = var.labels
  }
}

resource "helm_release" "bootstrap" {
  count = var.bootstrap_enabled ? 1 : 0

  name       = var.bootstrap_release_name
  namespace  = var.namespace
  repository = var.bootstrap_chart_repository
  chart      = var.bootstrap_chart_name
  version    = var.bootstrap_chart_version

  create_namespace = false

  wait            = var.wait
  timeout         = var.timeout_seconds
  cleanup_on_fail = var.cleanup_on_fail
  max_history     = var.max_history

  values = var.bootstrap_values

  depends_on = [
    helm_release.this
  ]
}

resource "helm_release" "this" {
  name       = var.release_name
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version
  namespace  = var.namespace

  create_namespace = !var.manage_namespace

  values = concat(
    [yamlencode(local.base_values)],
    var.additional_values
  )

  wait            = var.wait
  timeout         = var.timeout_seconds
  cleanup_on_fail = var.cleanup_on_fail
  max_history     = var.max_history

  depends_on = [
    kubernetes_namespace_v1.this
  ]
}