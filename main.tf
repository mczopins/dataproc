################################################################################################
#
#  NOTE: Before running the terraform scripts create the service account for the terraform
#
################################################################################################

# Enable Google API service
resource "google_project_service" "dataproc_service" {
  project     = var.project_id
  service     = "dataproc.googleapis.com"  # Replace with the desired service
  disable_on_destroy = true # Prevent disabling the service on Terraform destroy
}

# Create service account for the dataproc 
resource "google_service_account" "dataproc_sa" {
  depends_on   = [google_project_service.dataproc_service]  
  account_id   = var.account_id
  display_name = "Service Account for Dataproc"
}

# Map iam roles to the service account
resource "google_project_iam_member" "dataproc_role" {
  for_each = var.iam_roles  
  project = var.project_id
  role    = each.value["role"]
  member  = "serviceAccount:${google_service_account.dataproc_sa.email}"
}

# Create storage bucket for the jobs
resource "google_storage_bucket" "this" {
  depends_on    = [google_project_iam_member.dataproc_role]  
  name          = var.staging_bucket
  storage_class = "STANDARD"
  location      = "EU"
  uniform_bucket_level_access = true
  force_destroy = true
}

# Create Dataproc cluster
resource "google_dataproc_cluster" "this" {
  depends_on = [google_storage_bucket.this]  
  name     = var.cluster_name
  region   = var.region
  graceful_decommission_timeout = "120s"
  labels = {
    foo = "bar"
  }

  cluster_config {
    staging_bucket = var.staging_bucket

    endpoint_config {
      enable_http_port_access = false
    }

    master_config {
      num_instances = 1
      machine_type  = var.machine_type
      disk_config {
        boot_disk_type    = "pd-ssd"
        boot_disk_size_gb = 30
      }
    }

    worker_config {
      num_instances    = 2
      machine_type     = var.machine_type
      disk_config {
        boot_disk_size_gb = 30
        num_local_ssds    = 1
      }
    }

    preemptible_worker_config {
      num_instances = 0
    }

    # Override or set some custom properties
    software_config {
      image_version = var.image_version
      override_properties = {
        "dataproc:dataproc.allow.zero.workers" = "true"
      }
    }

    gce_cluster_config {
      zone = var.zone
      network = var.network
      internal_ip_only = true        
      tags = ["foo", "bar"]
      # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
      service_account = "${google_service_account.dataproc_sa.email}"
      shielded_instance_config {
        enable_secure_boot          = true
        enable_vtpm                 = true
        enable_integrity_monitoring = true
      }   
   
    }

    # You can define multiple initialization_action blocks
    initialization_action {
      script      = "gs://dataproc-initialization-actions/stackdriver/stackdriver.sh"
      timeout_sec = 500
    }
  }
}
