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


resource "google_kms_key_ring" "kms_keyring" {
  name     = var.kms_keyring_name
  location = var.network_region
  project  = google_project.app_dev_project.project_id

depends_on = [
time_sleep.wait_for_org_policy
]  

}



resource "google_kms_crypto_key" "signing_key" {
  name     = var.kms_key_name
  key_ring = google_kms_key_ring.kms_keyring.id
  purpose  = var.kms_key_purpose

  version_template {
    algorithm        = var.kms_key_algorithm
  #  protection_level = var.kms_protection_level # This attribute forces recreation of the resource
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [
google_kms_crypto_key.signing_key
]  

}


resource "google_container_analysis_note" "note" {
  name    = var.note_id
  project = google_project.app_dev_project.project_id

  short_description = var.note_description
  long_description  = var.note_description
  attestation_authority {
    hint {
      human_readable_name = var.note_description
    }
  }
  depends_on = [
time_sleep.wait_for_org_policy,
]  
  
}


data "google_kms_crypto_key_version" "signing_key_version" {
  crypto_key = google_kms_crypto_key.signing_key.id
  depends_on = [google_kms_crypto_key.signing_key]  

}

resource "google_binary_authorization_attestor" "attestor" {
  name    = var.attestor_name
  project = google_project.app_dev_project.project_id
  attestation_authority_note {
    note_reference = google_container_analysis_note.note.name
    public_keys {
      id = data.google_kms_crypto_key_version.signing_key_version.id
      pkix_public_key {
        public_key_pem      = data.google_kms_crypto_key_version.signing_key_version.public_key[0].pem
        signature_algorithm = data.google_kms_crypto_key_version.signing_key_version.public_key[0].algorithm
      }
    }
  }

  depends_on = [
data.google_kms_crypto_key_version.signing_key_version,
google_container_analysis_note.note,
]  
}

