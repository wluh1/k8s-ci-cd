variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 4
  description = "number of gke nodes"
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network         = google_compute_network.vpc.name
  subnetwork      = google_compute_subnetwork.subnet.name
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {}
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    service_account = "144918314093-compute@developer.gserviceaccount.com"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n2-standard-2"
    min_cpu_platform = "Intel Cascade Lake"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    image_type = "ubuntu"
  }
}

