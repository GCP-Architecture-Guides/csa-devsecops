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


#Setting up the IAM policy constraint. 
resource "google_project_organization_policy" "restrict_vpn_peer_ips" {
  project    = google_project.app_dev_project.project_id
  constraint = "constraints/compute.restrictVpnPeerIPs"
  list_policy {
    allow {
      all = true
    }
  }
  depends_on = [
    time_sleep.wait_enable_service_api,
  ]
}


# Set Org policies to allow unsheilded VM for workstation configuration
#Setting up the IAM policy constraint. 

module "org-policy-requireShieldedVm" {
  source      = "terraform-google-modules/org-policy/google"
  policy_for  = "project"
  project_id  = google_project.app_dev_project.project_id
  constraint  = "compute.requireShieldedVm"
  policy_type = "boolean"
  enforce     = false
  depends_on = [
    time_sleep.wait_enable_service_api,
  ]
}

## To allow access beyond your org; to be disabled before broader rollout
module "org-policy-domain-restricted-sharing" {
  source      = "terraform-google-modules/org-policy/google"
  policy_for  = "project"
  project_id  = google_project.app_dev_project.project_id
  constraint  = "iam.allowedPolicyMemberDomains"
  policy_type = "list"
  enforce     = false
  depends_on = [
    time_sleep.wait_enable_service_api,
  ]
}

/*

module "org-policy-vmExternalIpAccess" {
  source      = "terraform-google-modules/org-policy/google"
  policy_for  = "project"
  project_id  = google_project.app_dev_project.project_id
  constraint  = "compute.vmExternalIpAccess"
  policy_type = "list"
  enforce     = false
  depends_on = [
    time_sleep.wait_enable_service_api,
  ]
}
*/


resource "time_sleep" "wait_for_org_policy" {
  depends_on = [
    module.org-policy-requireShieldedVm,
     module.org-policy-domain-restricted-sharing,
    # module.org-policy-vmExternalIpAccess,  # Enable if module.org-policy-vmExternalIpAccess is enabled
      google_project_organization_policy.restrict_vpn_peer_ips,
  ]
  create_duration  = "180s"
  destroy_duration = "30s"
}
