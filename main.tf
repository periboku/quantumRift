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

  allow {
    protocol  = "tcp"
    ports     = ["80", "22"]
  }
  target_tags = ["gitlab-vm"]
  source_ranges = ["0.0.0.0/0"]
}


resource "google_service_account" "tf_sa" {
  account_id   = "service-account-id"
  display_name = "TF Service Account"
  project = "quantumrift"
}



# iam role for reading gcp bucket to download gitlab installation shell script
resource "google_service_account_iam_binding" "storage_reader" {
  service_account_id = google_service_account.tf_sa.name
  role               = "roles/storage.objectViewer"
  members = [
    "serviceAccount:google_service_account.tf_sa.email", 
  ]
}



/*
resource "google_service_account_iam_binding" "artifact_reader" {
  service_account_id = google_service_account.tf_sa.name
  role               = "roles/artifactregistry.reader"
  members = [
    "serviceAccount:google_service_account.tf_sa.email", 
  ]
}
*/





# gitlab-vm
resource "google_compute_instance" "default" {
    name         = "gitlab-vm"
    project      = "quantumrift"
    machine_type = "n2-standard-4"
    zone         = "europe-west3-a"
    tags         = ["gitlab-vm"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  service_account {
    email = google_service_account.tf_sa.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = "gsutil cp gs://gitlab-install/install_gitlab.sh  /tmp/; sudo chmod +x /tmp/install_gitlab.sh; ./install_gitlab.sh"


  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}




resource "google_storage_bucket" "static" {
 name          = "gitlab-install"
 location      = "EU"
 storage_class = "STANDARD"
 project = "quantumrift"

 uniform_bucket_level_access = true
}

# Upload a text file as an object
# to the storage bucket

resource "google_storage_bucket_object" "default" {
 name         = "install_gitlab.sh"
 source       = "~/install_gitlab.sh"
 content_type = "text/plain"
 bucket       = google_storage_bucket.static.id
}