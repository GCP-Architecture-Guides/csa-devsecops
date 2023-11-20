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


resource "google_dns_managed_zone" "cloud_dns" {
  name        = "source-google-com"
  dns_name    = "source.developers.google.com."
  description = "Cloud Source Repositories"
  project     = google_project.app_dev_project.project_id
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.primary_network.id
    }
  }
  depends_on = [
    google_compute_network.primary_network,
  ]
}


resource "google_dns_record_set" "dns_record_cname" {
  name         = "*.${google_dns_managed_zone.cloud_dns.dns_name}"
  managed_zone = google_dns_managed_zone.cloud_dns.name
  type         = "CNAME"
  ttl          = 300
  project      = google_project.app_dev_project.project_id
  rrdatas      = ["${google_dns_managed_zone.cloud_dns.dns_name}"]
  depends_on   = [google_dns_managed_zone.cloud_dns]
}

resource "google_dns_record_set" "dns_record_a" {
  name         = google_dns_managed_zone.cloud_dns.dns_name
  managed_zone = google_dns_managed_zone.cloud_dns.name
  type         = "A"
  ttl          = 300
  project      = google_project.app_dev_project.project_id
  rrdatas      = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
  depends_on   = [google_dns_managed_zone.cloud_dns]
}




resource "google_dns_managed_zone" "cloud_dns_googleapis" {
  name        = "googleapis-com"
  dns_name    = "googleapis.com."
  description = "Google APIs"
  project     = google_project.app_dev_project.project_id
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.primary_network.id
    }
  }
  depends_on = [
    google_compute_network.primary_network,
  ]
}


resource "google_dns_record_set" "dns_record_cname_apis" {
  name         = "*.${google_dns_managed_zone.cloud_dns_googleapis.dns_name}"
  managed_zone = google_dns_managed_zone.cloud_dns_googleapis.name
  type         = "CNAME"
  ttl          = 300
  project      = google_project.app_dev_project.project_id
  rrdatas      = ["${google_dns_managed_zone.cloud_dns_googleapis.dns_name}"]
  depends_on   = [google_dns_managed_zone.cloud_dns_googleapis]
}

resource "google_dns_record_set" "dns_record_a_apis" {
  name         = google_dns_managed_zone.cloud_dns_googleapis.dns_name
  managed_zone = google_dns_managed_zone.cloud_dns_googleapis.name
  type         = "A"
  ttl          = 300
  project      = google_project.app_dev_project.project_id
  rrdatas      = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
  depends_on   = [google_dns_managed_zone.cloud_dns_googleapis]
}




resource "google_dns_managed_zone" "cloud_dns_gcrio" {
  name        = "gcr-io"
  dns_name    = "gcr.io."
  description = "Google Container Registry"
  project     = google_project.app_dev_project.project_id
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.primary_network.id
    }
  }
  depends_on = [
    google_compute_network.primary_network,
  ]
}


resource "google_dns_record_set" "dns_record_cname_gcrio" {
  name         = "*.${google_dns_managed_zone.cloud_dns_gcrio.dns_name}"
  managed_zone = google_dns_managed_zone.cloud_dns_gcrio.name
  type         = "CNAME"
  ttl          = 300
  project      = google_project.app_dev_project.project_id
  rrdatas      = ["${google_dns_managed_zone.cloud_dns_gcrio.dns_name}"]
  depends_on   = [google_dns_managed_zone.cloud_dns_gcrio]
}

resource "google_dns_record_set" "dns_record_a_gcrio" {
  name         = google_dns_managed_zone.cloud_dns_gcrio.dns_name
  managed_zone = google_dns_managed_zone.cloud_dns_gcrio.name
  type         = "A"
  ttl          = 300
  project      = google_project.app_dev_project.project_id
  rrdatas      = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
  depends_on   = [google_dns_managed_zone.cloud_dns_gcrio]
}






resource "google_dns_managed_zone" "cloud_dns_pkg_dev" {
  name        = "pkg-dev"
  dns_name    = "pkg.dev."
  description = "Google Artifact Registry"
  project     = google_project.app_dev_project.project_id
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.primary_network.id
    }
  }
  depends_on = [
    google_compute_network.primary_network,
  ]
}


resource "google_dns_record_set" "dns_record_cname_pkg_dev" {
  name         = "*.${google_dns_managed_zone.cloud_dns_pkg_dev.dns_name}"
  managed_zone = google_dns_managed_zone.cloud_dns_pkg_dev.name
  type         = "CNAME"
  ttl          = 300
  project      = google_project.app_dev_project.project_id
  rrdatas      = ["${google_dns_managed_zone.cloud_dns_pkg_dev.dns_name}"]
  depends_on   = [google_dns_managed_zone.cloud_dns_pkg_dev]
}

resource "google_dns_record_set" "dns_record_a_pkg_dev" {
  name         = google_dns_managed_zone.cloud_dns_pkg_dev.dns_name
  managed_zone = google_dns_managed_zone.cloud_dns_pkg_dev.name
  type         = "A"
  ttl          = 300
  project      = google_project.app_dev_project.project_id
  rrdatas      = ["199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"]
  depends_on   = [google_dns_managed_zone.cloud_dns_pkg_dev]
}




## DNS for PSC Worksation 


resource "google_dns_managed_zone" "psc_cloud_dns" {
    count      = var.workstation_private_config == false ? 0 : 1
  name        = "private-workstation-cluster-zone"
  dns_name    = "${google_workstations_workstation_cluster.workstation_cluster.private_cluster_config[0].cluster_hostname}."
  description = "Private Workstation"
  project     = google_project.app_dev_project.project_id
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.primary_network.id
    }
  }
  depends_on = [
    google_compute_network.primary_network,
    google_workstations_workstation_cluster.workstation_cluster,
  ]
}


resource "google_dns_record_set" "psc_dns_record_cname" {
    count      = var.workstation_private_config == false ? 0 : 1
  name         = "*.${google_dns_managed_zone.psc_cloud_dns[count.index].dns_name}"
  managed_zone = google_dns_managed_zone.psc_cloud_dns[count.index].name
  type         = "A"
  ttl          = 300
  project      = google_project.app_dev_project.project_id
  rrdatas      = ["${google_compute_address.ipsec-interconnect-address[count.index].address}"]
  depends_on   = [
    google_dns_managed_zone.psc_cloud_dns,
    google_compute_address.ipsec-interconnect-address,
    ]
}
