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

# Creating adding random Id
resource "random_id" "random_suffix" {
  byte_length = 4
}



# Create Folder in GCP Organization
resource "google_folder" "app_dev" {
  display_name = "${var.folder_name}-${random_id.random_suffix.hex}"
  parent       = "organizations/${var.organization_id}"
}


# Create the project
resource "google_project" "app_dev_project" {
  billing_account = var.billing_account
  #org_id          = var.organization_id    # Only one of `org_id` or `folder_id` may be specified
  folder_id  = google_folder.app_dev.name   # Only one of `org_id` or `folder_id` may be specified
  name       = var.project_name
  project_id = "${var.project_name}-${random_id.random_suffix.hex}"
skip_delete = var.skip_delete
}




# Enable the necessary API services
resource "google_project_service" "api_service" {
  for_each = toset([
    "artifactregistry.googleapis.com",
    "autoscaling.googleapis.com",
    "binaryauthorization.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudbuild.googleapis.com",
    "clouddeploy.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudtrace.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containeranalysis.googleapis.com",
    "containerfilesystem.googleapis.com",
    "containerregistry.googleapis.com",
    "containerscanning.googleapis.com",
    "datastore.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "networkconnectivity.googleapis.com",
    "ondemandscanning.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "sourcerepo.googleapis.com",
    "sql-component.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "storage.googleapis.com",
    "workstations.googleapis.com",
  ])

  service                    = each.key
  project                    = google_project.app_dev_project.project_id
  disable_on_destroy         = false
  disable_dependent_services = true
}


# Wait delay after enabling APIs
resource "time_sleep" "wait_enable_service_api" {
  depends_on       = [google_project_service.api_service]
  create_duration  = "45s"
  destroy_duration = "45s"
}


