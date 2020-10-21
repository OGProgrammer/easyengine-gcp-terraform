## root public key
variable "ssh_key" {
  default = "~/.ssh/id_rsa.pub"
}

## network stuff
variable "office_01_ip" {
  default = "1.1.1.1" # Update to your office IP
}

variable "home_ip" {
  default = "1.1.1.1" # Update to your home IP
}

variable "subnetwork" {
  default = "10.20.0.0/16"
}

variable "app_subnetwork" {
  default = "10.20.30.0/24"
}

variable "db_subnetwork" {
  default = "10.20.80.0/24"
}

## GCP - Main Region
variable "hq-region" {
  default = "us-central1"
}

## GCP Availability Zone
variable "main-zone" {
  default = "a"
}

variable "gcp-project" {
  default = "the_gcp_project_name"
}

variable "corporate-tag" {
  default = "acme"
}
