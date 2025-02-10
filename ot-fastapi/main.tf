# Proveedor Kubernetes
module "provider" {
  source = "./provider.tf"
}

# Variables globales
module "variables" {
  source = "./variables.tf"
}

# Despliegue de la API
module "api_deployment" {
  source = "./deployments.tf"
}

# Despliegue del Worker
module "worker_deployment" {
  source = "./deployments.tf"
}

# Servicio para la API
module "api_service" {
  source = "./services.tf"
}

# Autoscaling de la API
module "api_autoscaler" {
  source = "./autoscalers.tf"
}
