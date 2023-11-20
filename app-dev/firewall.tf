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


# Enable SSH through IAP
resource "google_compute_firewall" "ids_allow_iap_proxy" {
  name      = "ssh-allow-iap-proxy"
  network   = google_compute_network.primary_network.id
  project   = google_project.app_dev_project.project_id
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]

  depends_on = [
    google_compute_network.primary_network
  ]
}


resource "google_compute_firewall" "allow_all_internal" {
  name    = "allow-all-internal"
  network = google_compute_network.primary_network.id
  project = google_project.app_dev_project.project_id
  allow {
    protocol = "tcp"

  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["192.168.0.0/20"]

  depends_on = [
    google_compute_network.primary_network
  ]
}


resource "google_compute_firewall" "allow_egress_workstations_control_plane" {
  name      = "allow-egress-workstations-control-plane"
  network   = google_compute_network.primary_network.id
  project   = google_project.app_dev_project.project_id
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443", "980"]
  }
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["cloud-workstations-instance"]

  depends_on = [
    google_compute_network.primary_network
  ]
}



resource "google_compute_firewall" "allow_ingress_workstations_control_plane" {
  name      = "allow-ingress-workstations-control-plane"
  network   = google_compute_network.primary_network.id
  project   = google_project.app_dev_project.project_id
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443", "980"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["cloud-workstations-instance"]

  depends_on = [
    google_compute_network.primary_network
  ]
}