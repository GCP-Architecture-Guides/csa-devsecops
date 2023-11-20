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



module "app-dev" {
  source                     = "./app-dev"
  organization_id            = var.organization_id
  billing_account            = var.billing_account
  project_name               = var.project_name
  vpc_network_name           = var.vpc_network_name
  vpc_subnetwork_name        = var.vpc_subnetwork_name
  network_region             = var.network_region
  network_zone               = var.network_zone
  ip_subnetwork_cidr_primary = var.ip_subnetwork_cidr_primary
  developer_service_account  = var.developer_service_account
  skip_delete                = var.skip_delete

  end_user_account      = var.end_user_account
  end_user_roles        = var.end_user_roles
  developer_roles       = var.developer_roles
  compute_default_roles = var.compute_default_roles


  gke_cluster_name                 = var.gke_cluster_name
  ip_subnetwork_cidr_pod_range     = var.ip_subnetwork_cidr_pod_range
  ip_subnetwork_cidr_service_range = var.ip_subnetwork_cidr_service_range
  gke_subnetwork_master_cidr_range = var.gke_subnetwork_master_cidr_range
#  git_user_account                 = var.git_user_account
#  git_user_email                   = var.git_user_email
#  git_user_name                    = var.git_user_name
private_pool_peering_vpc_name = var.private_pool_peering_vpc_name
reserved_range_name = var.reserved_range_name
private_pool_network = var.private_pool_network
private_pool_prefix = var.private_pool_prefix
private_pool_name = var.private_pool_name
gw_name_1 = var.gw_name_1
gw_name_2 = var.gw_name_2
peer_asn_1 = var.peer_asn_1
peer_asn_2 = var.peer_asn_2
ip_address_1 = var.ip_address_1
ip_address_2 = var.ip_address_2
ip_address_3 = var.ip_address_3
ip_address_4 = var.ip_address_4
router_name_1 = var.router_name_1
router_1_interface_name_0 = var.router_1_interface_name_0
router_1_interface_name_1 = var.router_1_interface_name_1
tunnel_name_gw1_if0 = var.tunnel_name_gw1_if0
tunnel_name_gw1_if1 = var.tunnel_name_gw1_if1
peer_name_gw1_if0 = var.peer_name_gw1_if0
peer_name_gw1_if1 = var.peer_name_gw1_if1
router_name_2 = var.router_name_2
router_2_interface_name_0 = var.router_2_interface_name_0
router_2_interface_name_1 = var.router_2_interface_name_1
tunnel_name_gw2_if0 = var.tunnel_name_gw2_if0
tunnel_name_gw2_if1 = var.tunnel_name_gw2_if1
peer_name_gw2_if0 = var.peer_name_gw2_if0
peer_name_gw2_if1 = var.peer_name_gw2_if1
mask_length = var.mask_length
kms_keyring_name = var.kms_keyring_name
kms_key_name = var.kms_key_name
kms_key_version = var.kms_key_version
kms_key_purpose = var.kms_key_purpose
kms_key_algorithm = var.kms_key_algorithm
kms_protection_level = var.kms_protection_level
note_id = var.note_id
note_description = var.note_description
attestor_name = var.attestor_name
folder_name = var.folder_name
workstation_image = var.workstation_image
workstation_private_config = var.workstation_private_config
}

