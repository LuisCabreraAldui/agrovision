resource "kubernetes_horizontal_pod_autoscaler" "api_hpa" {
  metadata {
    name      = "fastapi-app-hpa"
    namespace = var.namespace
  }

  spec {
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.api_deployment.metadata[0].name
      api_version = "apps/v1"
    }

    min_replicas = 2
    max_replicas = 10

    metrics {
      type = "Resource"
      resource {
        name = "cpu"
        target_average_utilization = 80
      }
    }
  }
}
