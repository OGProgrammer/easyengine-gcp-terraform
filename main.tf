provider "google" {
  version     = "~> 2.7"
  project     = var.gcp-project
  credentials = "/replace/this/to/the/pathofyour/credentials.json"
  region      = var.hq-region
  zone        = "${var.hq-region}-${var.main-zone}"
}

terraform {
  required_version = ">= 0.12"
}

# See install-namecheap-tf-provider.sh
//provider "namecheap" {
//  username    = "your_username"
//  api_user    = "your_username"
//  token       = "your_token"
//  ip          = var.office_01_ip
//  use_sandbox = false
//}

provider "random" {
  version = "~> 2.0"
}

# Project wide ssh-key
resource "google_compute_project_metadata_item" "ssh-keys" {
  key = "ssh-keys"

  value = <<EOF
admin:${file(var.ssh_key)}
EOF

}

