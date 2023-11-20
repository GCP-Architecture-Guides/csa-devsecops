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


variable "organization_id" {
  type        = string
  description = "organization id required"
}

variable "billing_account" {
  type        = string
  description = "billing account required"
}

variable "project_name" {
  type        = string
  description = "Project ID to deploy resources"
}

variable "developer_service_account" {
  type        = string
  description = "inner/outer dev loop service agent"
}

variable "folder_name" {
  type        = string
  description = "A folder to create this project under. If none is provided, the project will be created under the organization"
}


variable "skip_delete" {
  description = " If true, the Terraform resource can be deleted without deleting the Project via the Google API."

}

variable "workstation_image" {
  description = "The predefined container image to run on the Cloud Workstation. Options are listed here: https://cloud.google.com/workstations/docs/preconfigured-base-images#list_of_preconfigured_base_images"
  type        = string
}

variable "workstation_private_config" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = bool
}


variable "end_user_account" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = string
}


variable "developer_roles" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
}


variable "end_user_roles" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
}


variable "compute_default_roles" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
}


variable "vpc_network_name" {
  type        = string
  description = "VPC network name"
}


variable "vpc_subnetwork_name" {
  type        = string
  description = "VPC subnetwork name"
}

variable "network_region" {
  type        = string
  description = "Primary network region for micro segmentation architecture"
}

variable "network_zone" {
  type        = string
  description = "Primary network zone"
}


variable "ip_subnetwork_cidr_primary" {
  type        = string
  description = "Subnet range for primary presentation layer"
}


variable "ip_subnetwork_cidr_pod_range" {
  type        = string
  description = "Subnet range for primary presentation layer"
}

variable "ip_subnetwork_cidr_service_range" {
  type        = string
  description = "Subnet range for primary presentation layer"
}


variable "gke_subnetwork_master_cidr_range" {
  type        = string
  description = "Subnet range for primary presentation layer"
}


/*

variable "git_user_account" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = string
}

variable "git_user_email" {
  type        = string
  description = "User email for Git"
}

variable "git_user_name" {
  type        = string
  description = "User name for Git"
}
*/


variable "gke_cluster_name" {
  type        = string
  description = "GKE_CLUSTER_NAME"
}

variable "private_pool_peering_vpc_name" {
  type        = string
  description = "PRIVATE_POOL_PEERING_VPC_NAME"
}


variable "reserved_range_name" {
  type        = string
  description = "RESERVED_RANGE_NAME"
}



variable "private_pool_network" {
  type        = string
  description = "PRIVATE_POOL_NETWORK"
}


variable "private_pool_prefix" {
  type        = string
  description = "PRIVATE_POOL_PREFIX"
}




variable "private_pool_name" {
  type        = string
  description = "PRIVATE_POOL_NAME"
}


variable "gw_name_1" {
  type        = string
  description = "GW_NAME_1"
}



variable "gw_name_2" {
  type        = string
  description = "GW_NAME_2"
}



variable "peer_asn_1" {
  type        = number
  description = "PEER_ASN_1"
}



variable "peer_asn_2" {
  type        = number
  description = "PEER_ASN_2"
}



variable "ip_address_1" {
  type        = string
  description = "PEER_IP_ADDRESS_3=$IP_ADDRESS_1"
}



variable "ip_address_2" {
  type        = string
  description = "PEER_IP_ADDRESS_4=$IP_ADDRESS_2"
}



variable "ip_address_3" {
  type        = string
  description = "PEER_IP_ADDRESS_1=$IP_ADDRESS_3"
}




variable "ip_address_4" {
  type        = string
  description = "PEER_IP_ADDRESS_2=$IP_ADDRESS_4"
}




variable "router_name_1" {
  type        = string
  description = "ROUTER_NAME_1"
}



variable "router_1_interface_name_0" {
  type        = string
  description = "ROUTER_1_INTERFACE_NAME_0"
}



variable "router_1_interface_name_1" {
  type        = string
  description = "ROUTER_1_INTERFACE_NAME_1"
}



variable "tunnel_name_gw1_if0" {
  type        = string
  description = "TUNNEL_NAME_GW1_IF0"
}



variable "tunnel_name_gw1_if1" {
  type        = string
  description = "TUNNEL_NAME_GW1_IF1"
}



variable "peer_name_gw1_if0" {
  type        = string
  description = "PEER_NAME_GW1_IF0"
}



variable "peer_name_gw1_if1" {
  type        = string
  description = "PEER_NAME_GW1_IF1"
}



variable "router_name_2" {
  type        = string
  description = "ROUTER_NAME_2"
}


variable "router_2_interface_name_0" {
  type        = string
  description = "ROUTER_2_INTERFACE_NAME_0"
}



variable "router_2_interface_name_1" {
  type        = string
  description = "ROUTER_2_INTERFACE_NAME_1"
}



variable "tunnel_name_gw2_if0" {
  type        = string
  description = "TUNNEL_NAME_GW2_IF0"
}



variable "tunnel_name_gw2_if1" {
  type        = string
  description = "TUNNEL_NAME_GW2_IF1"
}



variable "peer_name_gw2_if0" {
  type        = string
  description = "PEER_NAME_GW2_IF0"
}



variable "peer_name_gw2_if1" {
  type        = string
  description = "PEER_NAME_GW2_IF1"
}



variable "mask_length" {
  type        = number
  description = "MASK_LENGTH"
}



variable "kms_keyring_name" {
  type        = string
  description = "kms keyring name"
}

variable "kms_key_name" {
  type        = string
  description = "kms key name"
}

variable "kms_key_version" {
  type        = number
  description = "kms key version"
}

variable "kms_key_purpose" {
  type        = string
  description = "kms key purpose"
}


variable "kms_key_algorithm" {
  type        = string
  description = "kms key algorithm"
}

variable "kms_protection_level" {
  type        = string
  description = "kms protection level"
}


variable "note_id" {
  type        = string
  description = "hello world attestor note"
}

variable "note_description" {
  type        = string
  description = "attestor note description for the spring hello world java app"
}

variable "attestor_name" {
  type        = string
  description = "attestor name"
}

