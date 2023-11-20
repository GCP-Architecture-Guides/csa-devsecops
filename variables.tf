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

# set specific variables here for your own deployment

/******************************
    REQUIRED TO CHANGE
******************************/

variable "organization_id" {
  type        = string
  description = "organization id required"
  default     = "XXXXXXXXXX"
}

variable "billing_account" {
  type        = string
  description = "billing account required"
  default     = "XXXXXX-XXXXXX-XXXXXX"
}

variable "end_user_account" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = string
  default     = "user:USER@DOMAIN.com"
}


/*****************************
RECOMMENDED DEFAULTS - Only change if needed
*****************************/

variable "folder_name" {
  type        = string
  default     = "CSA-AppDev"
  description = "A folder to create this project under. If none is provided, the project will be created under the organization"
}

variable "workstation_image" {
  description = "The predefined container image to run on the Cloud Workstation. Options are listed here: https://cloud.google.com/workstations/docs/preconfigured-base-images#list_of_preconfigured_base_images"
  type        = string
  default     = "us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest"
}

variable "workstation_private_config" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = bool
  default     = false
}

/*
variable "git_user_account" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = string
  default     = "test_user@example.com"
}


variable "git_user_name" {
  type        = string
  description = "User name for Git"
  default     = "Test User"
}

variable "git_user_email" {
  type        = string
  description = "User email for Git"
  default     = "test_user@example.com"
}
*/

variable "project_name" {
  type        = string
  description = "Project ID to deploy resources"
  default     = "csa-app-dev"
}

variable "developer_service_account" {
  type        = string
  description = "inner/outer dev loop service agent"
  default     = "developer-service-account"

}


variable "skip_delete" {
  description = " If true, the Terraform resource can be deleted without deleting the Project via the Google API."
  default     = "false"
}


variable "developer_roles" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
  default = [
    "roles/artifactregistry.writer",
    "roles/binaryauthorization.attestorsViewer",
    "roles/cloudbuild.builds.builder",
    "roles/clouddeploy.releaser",
    "roles/clouddeploy.serviceAgent",
    "roles/cloudkms.signerVerifier",
    "roles/containeranalysis.notes.attacher",
    "roles/containeranalysis.occurrences.editor",
    "roles/containeranalysis.notes.occurrences.viewer",
    "roles/logging.logWriter",
    "roles/ondemandscanning.admin",
    "roles/storage.objectCreator",
    "roles/storage.objectViewer",
    "roles/containeranalysis.notes.occurrences.viewer", # For BinAuth attestation
    "roles/binaryauthorization.attestorsVerifier",      # For BinAuth attestation
    "roles/source.reader",
  ]
}



variable "end_user_roles" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
  default = [
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.serviceAccountAdmin",
  ]
}



variable "compute_default_roles" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
  default = [
    "roles/clouddeploy.serviceAgent",
    "roles/cloudbuild.serviceAgent",
    "roles/container.serviceAgent",
    #   "roles/compute.serviceAgent",  # This role was added during troubleshoot
    #   "roles/editor",                # This role was added during troubleshoot
    "roles/logging.logWriter",
    "roles/storage.objectCreator",
    "roles/storage.objectViewer",
  ]
}




variable "vpc_network_name" {
  type        = string
  description = "VPC network name"
  default     = "hello-world-network"
}

variable "vpc_subnetwork_name" {
  type        = string
  description = "VPC subnetwork name"
  default     = "hello-world-cluster-subnet"
}

variable "network_region" {
  type        = string
  description = "Primary network region for micro segmentation architecture"
  default     = "us-central1"
}

variable "network_zone" {
  type        = string
  description = "Primary network zone"
  default     = "us-central1-a"
}


variable "ip_subnetwork_cidr_primary" {
  type        = string
  description = "Subnet range for primary presentation layer"
  default     = "192.168.0.0/20"
}


variable "ip_subnetwork_cidr_pod_range" {
  type        = string
  description = "Subnet range for primary presentation layer"
  default     = "10.4.0.0/14"
}

variable "ip_subnetwork_cidr_service_range" {
  type        = string
  description = "Subnet range for primary presentation layer"
  default     = "10.0.32.0/20"
}


variable "gke_subnetwork_master_cidr_range" {
  type        = string
  description = "Subnet range for primary presentation layer"
  default     = "172.16.0.0/28"
}


variable "gke_cluster_name" {
  type        = string
  description = "GKE_CLUSTER_NAME"
  default     = "hello-world-cluster"
}

variable "private_pool_peering_vpc_name" {
  type        = string
  description = "PRIVATE_POOL_PEERING_VPC_NAME"
  default     = "hello-world-cloud-build-central-vpc"
}


variable "reserved_range_name" {
  type        = string
  description = "RESERVED_RANGE_NAME"
  default     = "private-pool-addresses"
}



variable "private_pool_network" {
  type        = string
  description = "PRIVATE_POOL_NETWORK"
  default     = "192.168.16.0"
}


variable "private_pool_prefix" {
  type        = string
  description = "PRIVATE_POOL_PREFIX"
  default     = "20"
}




variable "private_pool_name" {
  type        = string
  description = "PRIVATE_POOL_NAME"
  default     = "hello-world-private-pool"
}


variable "gw_name_1" {
  type        = string
  description = "GW_NAME_1"
  default     = "private-peer-gateway"
}



variable "gw_name_2" {
  type        = string
  description = "GW_NAME_2"
  default     = "gke-central-gateway"
}



variable "peer_asn_1" {
  type        = number
  description = "PEER_ASN_1"
  default     = 65001
}



variable "peer_asn_2" {
  type        = number
  description = "PEER_ASN_2"
  default     = 65002
}



variable "ip_address_1" {
  type        = string
  description = "PEER_IP_ADDRESS_3=$IP_ADDRESS_1"
  default     = "169.254.2.1"
}



variable "ip_address_2" {
  type        = string
  description = "PEER_IP_ADDRESS_4=$IP_ADDRESS_2"
  default     = "169.254.3.1"
}



variable "ip_address_3" {
  type        = string
  description = "PEER_IP_ADDRESS_1=$IP_ADDRESS_3"
  default     = "169.254.2.2"
}




variable "ip_address_4" {
  type        = string
  description = "PEER_IP_ADDRESS_2=$IP_ADDRESS_4"
  default     = "169.254.3.2"
}




variable "router_name_1" {
  type        = string
  description = "ROUTER_NAME_1"
  default     = "cloud-build-router"
}



variable "router_1_interface_name_0" {
  type        = string
  description = "ROUTER_1_INTERFACE_NAME_0"
  default     = "cloud-build-interface-if0"
}



variable "router_1_interface_name_1" {
  type        = string
  description = "ROUTER_1_INTERFACE_NAME_1"
  default     = "cloud-build-interface-if1"
}



variable "tunnel_name_gw1_if0" {
  type        = string
  description = "TUNNEL_NAME_GW1_IF0"
  default     = "gke-central-tunnel-if0"
}



variable "tunnel_name_gw1_if1" {
  type        = string
  description = "TUNNEL_NAME_GW1_IF1"
  default     = "gke-central-tunnel-if1"
}



variable "peer_name_gw1_if0" {
  type        = string
  description = "PEER_NAME_GW1_IF0"
  default     = "cloud-build-peer-if0"
}



variable "peer_name_gw1_if1" {
  type        = string
  description = "PEER_NAME_GW1_IF1"
  default     = "cloud-build-peer-if1"
}



variable "router_name_2" {
  type        = string
  description = "ROUTER_NAME_2"
  default     = "gke-central-router"
}


variable "router_2_interface_name_0" {
  type        = string
  description = "ROUTER_2_INTERFACE_NAME_0"
  default     = "gke-central-interface-if0"
}



variable "router_2_interface_name_1" {
  type        = string
  description = "ROUTER_2_INTERFACE_NAME_1"
  default     = "gke-central-interface-if1"
}



variable "tunnel_name_gw2_if0" {
  type        = string
  description = "TUNNEL_NAME_GW2_IF0"
  default     = "cloud-build-tunnel-if0"
}



variable "tunnel_name_gw2_if1" {
  type        = string
  description = "TUNNEL_NAME_GW2_IF1"
  default     = "cloud-build-tunnel-if1"
}



variable "peer_name_gw2_if0" {
  type        = string
  description = "PEER_NAME_GW2_IF0"
  default     = "gke-central-peer-if0"
}



variable "peer_name_gw2_if1" {
  type        = string
  description = "PEER_NAME_GW2_IF1"
  default     = "gke-central-peer-if1"
}



variable "mask_length" {
  type        = number
  description = "MASK_LENGTH"
  default     = 30
}



variable "kms_keyring_name" {
  type        = string
  description = "kms keyring name"
  default     = "hello-world-keyring1"
}

variable "kms_key_name" {
  type        = string
  description = "kms key name"
  default     = "hello-world-key1"
}

variable "kms_key_version" {
  type        = number
  description = "kms key version"
  default     = 1
}

variable "kms_key_purpose" {
  type        = string
  description = "kms key purpose"
  default     = "ASYMMETRIC_SIGN"
}


variable "kms_key_algorithm" {
  type        = string
  description = "kms key algorithm"
  default     = "EC_SIGN_P256_SHA256"
}

variable "kms_protection_level" {
  type        = string
  description = "kms protection level"
  default     = "software"
}


variable "note_id" {
  type        = string
  description = "hello world attestor note"
  default     = "hello-world-attestor-note"
}

variable "note_description" {
  type        = string
  description = "attestor note description for the spring hello world java app"
  default     = "attestor note for the spring hello world java app"
}

variable "attestor_name" {
  type        = string
  description = "attestor name"
  default     = "hello-world-attestor"
}






