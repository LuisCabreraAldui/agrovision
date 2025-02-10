# Proveedor Kubernetes
provider "kubernetes" {
  config_path = "/etc/rancher/k3s/k3s.yaml"
}

# Variables
variable "api_replicas" {
  description = "Initial replicas for API deployment"
  default     = 2
}

variable "worker_replicas" {
  description = "Initial replicas for Worker deployment"
  default     = 1
}

variable "namespace" {
  description = "Kubernetes namespace"
  default     = "default"
}

# API Deployment
resource "kubernetes_deployment" "api_deployment" {
  metadata {
    name      = "fastapi-app"
    namespace = var.namespace
  }

  spec {
    replicas = var.api_replicas
    selector {
      match_labels = {
        app = "fastapi-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "fastapi-app"
        }
      }

      spec {
        container {
          image = "fastapi-app:latest"
          name  = "fastapi-container"
          resources {
            requests = {
              cpu    = "250m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }
          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

# Worker Deployment
resource "kubernetes_deployment" "worker_deployment" {
  metadata {
    name      = "fastapi-worker"
    namespace = var.namespace
  }

  spec {
    replicas = var.worker_replicas
    selector {
      match_labels = {
        app = "fastapi-worker"
      }
    }

    template {
      metadata {
        labels = {
          app = "fastapi-worker"
        }
      }

      spec {
        container {
          image = "fastapi-worker:latest"
          name  = "worker-container"
          resources {
            requests = {
              cpu    = "250m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

# API Service
resource "kubernetes_service" "api_service" {
  metadata {
    name      = "fastapi-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "fastapi-app"
    }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "NodePort"
  }
}

# Autoscaler for API

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

    metric {
      type = "Resource"
      resource {
        name                     = "cpu"
        target_average_value     = "80m" # Define el valor promedio objetivo (en milicores)
      }
    }
  }
}

# resource "kubernetes_horizontal_pod_autoscaler" "api_hpa" {
#   metadata {
#     name      = "fastapi-app-hpa"
#     namespace = var.namespace
#   }

#   spec {
#     scale_target_ref {
#       kind = "Deployment"
#       name = kubernetes_deployment.api_deployment.metadata[0].name
#       api_version = "apps/v1"
#     }
#     min_replicas = 2
#     max_replicas = 10
#     metrics {
#       type = "Resource"
#       resource {
#         name = "cpu"
#         target_average_utilization = 80
#       }
#     }
#   }
# }

# Outputs
output "api_service_url" {
  value = kubernetes_service.api_service.spec[0].cluster_ip
}

output "api_replicas" {
  value = kubernetes_deployment.api_deployment.spec[0].replicas
}

output "worker_replicas" {
  value = kubernetes_deployment.worker_deployment.spec[0].replicas
}
