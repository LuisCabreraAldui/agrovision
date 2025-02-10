output "api_service_url" {
  value = kubernetes_service.api_service.spec[0].cluster_ip
}

output "api_replicas" {
  value = kubernetes_deployment.api_deployment.spec[0].replicas
}

output "worker_replicas" {
  value = kubernetes_deployment.worker_deployment.spec[0].replicas
}
