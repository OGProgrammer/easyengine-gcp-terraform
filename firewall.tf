resource "google_compute_firewall" "acme_ping" {
  name    = "acme-ping"
  network = google_compute_network.acme_main_vpc.self_link

  allow {
    protocol = "icmp"
  }

  target_tags   = ["pingable"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "acme_https" {
  name    = "acme-https"
  network = google_compute_network.acme_main_vpc.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags   = ["https-server"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "acme_http" {
  name    = "acme-http"
  network = google_compute_network.acme_main_vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http-server"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "acme_ssh" {
  name    = "acme-ssh"
  network = google_compute_network.acme_main_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh"]
  source_ranges = [
    var.app_subnetwork,  // Local Network SSH Access
    "${var.home_ip}/32", // Home IP
    "${var.office_01_ip}/32",
  ]
}