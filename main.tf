resource "google_compute_network" "vpc_network" {
  name                    = "vm-network"
  project                 = "quantumrift"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
    name          = "vm-subnet"
    project       = "quantumrift"
    ip_cidr_range = "10.0.1.0/24"
    region        = "europe-west3"
    network       = google_compute_network.vpc_network.id
}


resource "google_compute_instance" "default" {
    name         = "gitlab-vm"
    project       = "quantumrift"
    machine_type = "n2-standard-4"
    zone         = "europe-west3"
    tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install gitlab-ce 
  metadata_startup_script = "sudo apt-get update; sudo apt-get upgrade; sudo adduser gituser; sudo usermod -aG sudo gituser;"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}