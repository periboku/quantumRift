# vpc for quantum rift project
resource "google_compute_network" "vpc_network" {
  name                    = "vm-network"
  project                 = "quantumrift"
  auto_create_subnetworks = false
  mtu                     = 1460
}

# subnet for gitlab vm
resource "google_compute_subnetwork" "default" {
    name          = "vm-subnet"
    project       = "quantumrift"
    ip_cidr_range = "10.0.1.0/24"
    region        = "europe-west3"
    network       = google_compute_network.vpc_network.id
}


# Creating firewall rule for gitlab vm
resource "google_compute_firewall" "rules" {
  project     = "quantumrift"
  name        = "gitlab-fw-rule"
  network     = "vm-network"
  description = "Creates firewall rule targeting tagged instances"
  depends_on = [ google_compute_instance.default ]

  allow {
    protocol  = "tcp"
    ports     = ["80", "22"]
  }
  target_tags = ["gitlab-vm"]
  source_ranges = ["0.0.0.0/0"]
}


# gitlab-vm
resource "google_compute_instance" "default" {
    name         = "gitlab-vm"
    project      = "quantumrift"
    machine_type = "n2-standard-2"
    zone         = "europe-west3-a"
    tags         = ["gitlab-vm"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }


  metadata_startup_script = "sudo apt update; sudo apt install git -y; git clone https://github.com/periboku/quantumRift.git; cd quantumRift/; chmod +x install_gitlab.sh; sudo ./install_gitlab.sh"


  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}


resource "google_service_account" "k8s-sa" {
  account_id   = "service-account-id"
  display_name = "K8S Service Account"
  project = "quantumrift"
}


# Role binding to service account for GKE
resource "google_project_iam_member" "k8s-role-binging-sa" {
  for_each = toset([
    "roles/artifactregistry.admin",
    "roles/container.developer",
    "roles/binaryauthorization.attestorsViewer",
    "roles/cloudkms.cryptoOperator",
    "roles/cloudkms.publicKeyViewer",
  ])
  role = each.key
  member = "serviceAccount:${google_service_account.k8s-sa.email}"
  project = "quantumrift"
}

resource "google_container_cluster" "primary" {
  name     = "quantumriftCluster"
  location = "europe-west3"
  project = "quantumrift"
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection = false
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "node-pool"
  location   = "europe-west3"
  cluster    = google_container_cluster.primary.name
  node_count = 1
  project = "quantumrift"

  node_config {
    preemptible  = true
    machine_type = "n2-standard-2"
    service_account = google_service_account.k8s-sa.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}