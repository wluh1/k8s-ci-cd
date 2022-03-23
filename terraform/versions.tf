terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.15.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.15.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.2"
    }
  }

  required_version = ">= 0.14"
}
