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


resource "google_cloudbuild_trigger" "cloud_source_repositories" {
  name     = "cloud-source-repositories"
  project  = google_project.app_dev_project.project_id
  location = var.network_region

  trigger_template {
    branch_name = "master"
    repo_name   = "hello-world-java"
  }
 substitutions = {
    _REPO_URL= "$(csr.url)"
  }

  service_account = google_service_account.developer_service_account.id
  filename        = "cloudbuild-launcher.yaml"
   depends_on = [
    resource.null_resource.installer,
  ]
}
