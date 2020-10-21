module "my-server" {
  source     = "./tf-gcp-wp-server"
  subnetwork = google_compute_subnetwork.acme_gblappnet.self_link
  region     = var.hq-region
  zone       = var.main-zone
  vendor     = var.corporate-tag
  server-tag = "prod001"
  disk-size  = 40

  # Upgraded server
  machine-type = "n1-standard-2"
}

