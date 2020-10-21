resource "google_compute_network" "acme_main_vpc" {
  name                    = "tf-acme"
  auto_create_subnetworks = "true"
}

resource "google_compute_subnetwork" "acme_gblappnet" {
  name          = "tf-acme-gblappnet"
  ip_cidr_range = var.app_subnetwork
  network       = google_compute_network.acme_main_vpc.self_link
}

resource "google_compute_subnetwork" "acme_dbnet" {
  name                     = "tf-acme-dbnet"
  ip_cidr_range            = var.db_subnetwork
  network                  = google_compute_network.acme_main_vpc.self_link
  private_ip_google_access = true
}

