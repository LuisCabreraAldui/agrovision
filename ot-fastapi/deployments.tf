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
