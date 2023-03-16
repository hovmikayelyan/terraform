#-------------------------------------------------
# My Terraform
#
# Use Terraform with GCP - Google Cloud Platform
#
# Made by Hov Mikayelyan
#-------------------------------------------------

provider "google" {
  credentials = file("file-from-gcp-token.json")
  project     = "project_name"
  region      = "us-west1"
  zone        = "us-west1-b"
}

resource "google_compute_instance" "my_server" {
  name         = "my-gcp-server"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
  }
}
