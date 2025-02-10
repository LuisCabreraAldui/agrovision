resource "kubernetes_service" "fastapi_service" {
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
