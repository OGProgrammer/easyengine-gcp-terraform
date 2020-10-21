# Required vars

variable "subnetwork" {
  description = "Pass a PUBLIC subnetwork into here!"
}

variable "region" {
  description = "GCP region"
}

variable "zone" {
  description = "GCP zone"
}

variable "vendor" {
  description = "A short 2-4 char tag for your corp biz name. Ex. acme"
}

variable "server-tag" {
  description = "A short 2-4 char tag for this specific server. Ex. 007"
}

# Optional vars

variable "disk-size" {
  default = "30"
}

variable "debian-version" {
  default = "debian-10"
}

variable "protect-from-deletion" {
  default = "true"
}

variable "machine-type" {
  default = "n1-standard-1"
}

variable "env" {
  default = "prod"
}
