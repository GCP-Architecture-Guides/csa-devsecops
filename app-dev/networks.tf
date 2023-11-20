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


# Create VPC network
resource "google_compute_network" "primary_network" {
  name = var.vpc_network_name
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
  project                         = google_project.app_dev_project.project_id
  depends_on = [
    time_sleep.wait_for_org_policy,
  ]
}


### TO to updated
resource "google_compute_subnetwork" "vpc_subnetwork" {
  name = var.vpc_subnetwork_name
  #  provider      = google-beta
  ip_cidr_range = var.ip_subnetwork_cidr_primary
  region        = var.network_region
  network       = google_compute_network.primary_network.id
  project       = google_project.app_dev_project.project_id
  # Enabling VPC flow logs
  # log_config {
  #   aggregation_interval = "INTERVAL_10_MIN"
  #   flow_sampling        = 0.5
  #   metadata             = "INCLUDE_ALL_METADATA"
  # }
  # Enable private Google access to be added in v2

  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = var.ip_subnetwork_cidr_pod_range
  }
  secondary_ip_range {
    range_name    = "service-range"
    ip_cidr_range = var.ip_subnetwork_cidr_service_range
  }

  private_ip_google_access = true
  depends_on = [
    google_compute_network.primary_network,
  ]
}
