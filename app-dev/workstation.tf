##  Copyright 2023 Google LLC
##  
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##  
##      https://www.apache.org/licenses/LICENSE-2.0
##  
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.


##  This code creates demo environment for CSA - Application Development Architecture Pattern   ##
##  This demo code is not built for production workload ##


resource "google_workstations_workstation_cluster" "workstation_cluster" {
  provider               = google-beta
  workstation_cluster_id = "workstation-cluster"
  network                = google_compute_network.primary_network.id
  subnetwork             = google_compute_subnetwork.vpc_subnetwork.id
  location               = var.network_region
  project                = google_project.app_dev_project.project_id

  dynamic "private_cluster_config" {
    for_each = var.workstation_private_config == false ? [] : [true]
      content {
        enable_private_endpoint = true
      }
  }


  depends_on = [
    google_compute_subnetwork.vpc_subnetwork,
  ]
}



resource "google_compute_address" "ipsec-interconnect-address" {
count      = var.workstation_private_config == false ? 0 : 1    
  name          = "workstation-psc-address"
  address_type  = "INTERNAL"
#  purpose       = "PRIVATE_SERVICE_CONNECT"
#  address       = "192.168.1.0"
#  prefix_length = 29
#  network       = google_compute_network.primary_network.self_link
  subnetwork             =  google_compute_subnetwork.vpc_subnetwork.id
  region  = var.network_region
    project                = google_project.app_dev_project.project_id



}


resource "google_compute_forwarding_rule" "default" {
    count      = var.workstation_private_config == false ? 0 : 1
  name                    = "private-workstation-endpoint"
  region  = var.network_region
    project                = google_project.app_dev_project.project_id

  load_balancing_scheme   = ""
  target                  = google_workstations_workstation_cluster.workstation_cluster.private_cluster_config[0].service_attachment_uri
 network                = google_compute_network.primary_network.id
  ip_address              = google_compute_address.ipsec-interconnect-address[count.index].id
 #   subnetwork             =  google_compute_subnetwork.vpc_subnetwork.id

 # allow_psc_global_access = true
# service_directory_registrations {
 #   namespace = "projects/${google_project.app_dev_project.project_id}/locations/${var.network_region}/namespaces/hello-world-ns"
 #}
}



resource "google_workstations_workstation_config" "workstation_cluster_config" {
  provider               = google-beta
  workstation_config_id  = "workstation-config"
  workstation_cluster_id = google_workstations_workstation_cluster.workstation_cluster.workstation_cluster_id
  location               = var.network_region
  project                = google_project.app_dev_project.project_id

  idle_timeout    = "3600s"

  host {
    gce_instance {
      service_account = "${google_service_account.developer_service_account.email}"
      service_account_scopes = ["https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/userinfo.email","https://www.googleapis.com/auth/cloud-platform"]
      machine_type = "e2-standard-4"
      # boot_disk_size_gb           = 35
      disable_public_ip_addresses = true
      shielded_instance_config {
        enable_secure_boot          = true
        enable_vtpm                 = true
        enable_integrity_monitoring = true
      }
    }
  }

  persistent_directories {
    mount_path = "/home"
    gce_pd {
      size_gb        = 200
      fs_type        = "ext4"
      disk_type      = "pd-standard"
      reclaim_policy = "DELETE"
    }
  }

  container {
    image = var.workstation_image
  }

  depends_on = [
    google_workstations_workstation_cluster.workstation_cluster,
    google_service_account.developer_service_account
  ]
}


resource "google_workstations_workstation" "hello_world_workstation" {
  provider              = google-beta
  workstation_id        = "hello-world-workstation"
  workstation_config_id = google_workstations_workstation_config.workstation_cluster_config.workstation_config_id
  workstation_cluster_id = google_workstations_workstation_cluster.workstation_cluster.workstation_cluster_id
  location               = var.network_region
  project                = google_project.app_dev_project.project_id

  depends_on = [
    google_workstations_workstation_config.workstation_cluster_config,
  ]
}

resource "null_resource" "start_workstaion" {
  triggers = {
    #   always_run = "${timestamp()}"
    w_id = "${google_workstations_workstation.hello_world_workstation.workstation_id}"
  }

  provisioner "local-exec" {
    command = <<-EOT
    gcloud config set project ${google_project.app_dev_project.project_id}
    gcloud workstations start ${google_workstations_workstation.hello_world_workstation.workstation_id} --region ${var.network_region} --cluster ${google_workstations_workstation_cluster.workstation_cluster.workstation_cluster_id} --config workstation-config
    gcloud config unset project
    EOT
  }
  depends_on = [google_workstations_workstation.hello_world_workstation]
}

