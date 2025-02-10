# Proveedor Kubernetes
module "provider" {
  source = "./module/provider.tf"
}

# Variables globales
module "variables" {
  source = "./module/variables.tf"
}

# Despliegue de la API
module "api_deployment" {
  source = "./module/deployments.tf"
}

# Despliegue del Worker
module "worker_deployment" {
  source = "./module/deployments.tf"
}

# Servicio para la API
module "api_service" {
  source = "./module/services.tf"
}

# Autoscaling de la API
module "api_autoscaler" {
  source = "./module/autoscalers.tf"
}
