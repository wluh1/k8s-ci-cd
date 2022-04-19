provider "helm" {
  kubernetes {
    host                   = "https://${data.terraform_remote_state.gke.outputs.kubernetes_cluster_host}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}
