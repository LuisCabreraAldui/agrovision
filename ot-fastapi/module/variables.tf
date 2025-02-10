variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  default     = "fastapi-cluster"
}

variable "api_replicas" {
  description = "Initial number of replicas for the API deployment"
  default     = 2
}

variable "worker_replicas" {
  description = "Initial number of replicas for the Worker process"
  default     = 1
}

variable "namespace" {
  description = "Kubernetes namespace to deploy resources"
  default     = "default"
}