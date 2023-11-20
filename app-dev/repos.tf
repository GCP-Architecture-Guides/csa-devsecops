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



resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.network_region
  repository_id = "hello-world-docker-repository"
  description   = "Sample Hello World Docker repo"
  format        = "DOCKER"
  project       = google_project.app_dev_project.project_id
  depends_on = [
    time_sleep.wait_for_org_policy,
  ]
}



resource "google_sourcerepo_repository" "my-repo" {
  name = "hello-world-java"
  project       = google_project.app_dev_project.project_id
  depends_on = [
    time_sleep.wait_for_org_policy,
  ]
}

