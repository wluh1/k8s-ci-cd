provider "google-beta" {
  project = var.project_id
  region  = var.region
}

resource "google_artifact_registry_repository" "podtato-head-repo" {
  provider = google-beta

  location      = var.region
  repository_id = "podtato-head"
  description   = "repository for podtato head example app"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "member" {
  depends_on = [google_artifact_registry_repository.podtato-head-repo]
  provider   = google-beta
  project    = google_artifact_registry_repository.podtato-head-repo.project
  location   = google_artifact_registry_repository.podtato-head-repo.location
  repository = google_artifact_registry_repository.podtato-head-repo.name
  role       = "roles/viewer"
  member     = "serviceAccount:144918314093-compute@developer.gserviceaccount.com"
}
