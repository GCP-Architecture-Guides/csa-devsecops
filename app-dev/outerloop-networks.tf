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

# VPN_SHARED_SECRET
resource "random_password" "vpn_shared_secret" {
  length      = 24
  min_lower   = 3
  min_numeric = 3
  min_special = 5
  min_upper   = 3
  depends_on = [
    time_sleep.wait_enable_service_api,
  ]
}


# Create  PRIVATE_POOL_PEERING_VPC
resource "google_compute_network" "private_pool_peering_vpc_name" {
  name = var.private_pool_peering_vpc_name
  #  provider                = google-beta
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
  project                         = google_project.app_dev_project.project_id
  depends_on = [
    time_sleep.wait_for_org_policy,

  ]
}


resource "google_compute_global_address" "reserved_range" {
  name          = var.reserved_range_name
  purpose       = "VPC_PEERING"
  address       = var.private_pool_network
  prefix_length = var.private_pool_prefix
  network       = google_compute_network.private_pool_peering_vpc_name.id
  project       = google_project.app_dev_project.project_id
  address_type  = "INTERNAL"
  depends_on = [
    google_compute_network.private_pool_peering_vpc_name,
  ]
}




resource "null_resource" "update_network_peering" {
  triggers = {
  #  always_run = "${timestamp()}"
  gke_peering = "${google_container_cluster.hello_world_cluster.private_cluster_config[0].peering_name}"
  nw_name = "${google_compute_network.primary_network.name}"
  }

  provisioner "local-exec" {
    #interpreter = ["bash", "-c"]
    command = <<-EOT
gcloud compute networks peerings update ${google_container_cluster.hello_world_cluster.private_cluster_config[0].peering_name} \
  --network=${google_compute_network.primary_network.name} \
  --export-custom-routes \
  --no-export-subnet-routes-with-public-ip \
  --project=${google_project.app_dev_project.project_id}
EOT

  }
  depends_on = [
    google_compute_network.primary_network,
    google_container_cluster.hello_world_cluster,
  ]
}



resource "google_service_networking_connection" "private_service_connection" {
  network                 = google_compute_network.private_pool_peering_vpc_name.id
  reserved_peering_ranges = [google_compute_global_address.reserved_range.name]
  service                 = "servicenetworking.googleapis.com"
  depends_on = [
    google_compute_global_address.reserved_range,
    google_compute_network.private_pool_peering_vpc_name,
  ]
}



# (Optional) Import or export custom routes
resource "google_compute_network_peering_routes_config" "peering_routes" {
  peering = google_service_networking_connection.private_service_connection.peering
  network = google_compute_network.private_pool_peering_vpc_name.name
  project                         = google_project.app_dev_project.project_id

  import_custom_routes = true
  export_custom_routes = true
  depends_on = [
google_service_networking_connection.private_service_connection
]  
}



resource "google_cloudbuild_worker_pool" "private_pool" {
  name     = var.private_pool_name
  location = var.network_region
  project  = google_project.app_dev_project.project_id
  network_config {
    peered_network = google_compute_network.private_pool_peering_vpc_name.id
  }

  worker_config {
    disk_size_gb = 100
    machine_type = "e2-standard-4"
    no_external_ip = true
  }
  depends_on = [
    google_compute_network_peering_routes_config.peering_routes,
  ]
}



resource "google_compute_ha_vpn_gateway" "vpn_gateway_1" {
  name    = var.gw_name_1
  network = google_compute_network.private_pool_peering_vpc_name.id
  region  = var.network_region
  project = google_project.app_dev_project.project_id
  stack_type = "IPV4_ONLY"
  depends_on = [
    google_compute_network.private_pool_peering_vpc_name,
  ]
}


resource "google_compute_ha_vpn_gateway" "vpn_gateway_2" {
  name    = var.gw_name_2
  network = google_compute_network.primary_network.id
  region  = var.network_region
  project = google_project.app_dev_project.project_id
  stack_type = "IPV4_ONLY"
  depends_on = [
    google_compute_network.primary_network,
  ]
}



# Create a CloudRouter 1
resource "google_compute_router" "router_name_1" {
  name    = var.router_name_1
  project = google_project.app_dev_project.project_id
  network = google_compute_network.private_pool_peering_vpc_name.id
  region  = var.network_region
  bgp {
    asn = var.peer_asn_1
  }
  depends_on = [
    google_compute_network.private_pool_peering_vpc_name,
  ]
}



# Create a CloudRouter 2
resource "google_compute_router" "router_name_2" {
  name    = var.router_name_2
  project = google_project.app_dev_project.project_id
  network = google_compute_network.primary_network.id
  region  = var.network_region
  bgp {
    asn = var.peer_asn_2
  }
  depends_on = [
    google_compute_network.primary_network,
  ]
}



resource "google_compute_vpn_tunnel" "vpn_tunnel_gw1_if0" {
  name             = var.tunnel_name_gw1_if0
  region           = var.network_region
  project          = google_project.app_dev_project.project_id
  peer_gcp_gateway = google_compute_ha_vpn_gateway.vpn_gateway_2.id

  shared_secret = random_password.vpn_shared_secret.result

  vpn_gateway = google_compute_ha_vpn_gateway.vpn_gateway_1.id
  router      = google_compute_router.router_name_1.id

  vpn_gateway_interface = 0

  ike_version = 2

   depends_on = [
 google_compute_ha_vpn_gateway.vpn_gateway_1,
 google_compute_router.router_name_1,
 random_password.vpn_shared_secret,
 google_compute_ha_vpn_gateway.vpn_gateway_2,
  ]
}




resource "google_compute_vpn_tunnel" "vpn_tunnel_gw1_if1" {
  name             = var.tunnel_name_gw1_if1
  region           = var.network_region
  project          = google_project.app_dev_project.project_id
  peer_gcp_gateway = google_compute_ha_vpn_gateway.vpn_gateway_2.id

  shared_secret = random_password.vpn_shared_secret.result

  vpn_gateway = google_compute_ha_vpn_gateway.vpn_gateway_1.id
  router      = google_compute_router.router_name_1.id

  vpn_gateway_interface = 1

  ike_version = 2

     depends_on = [
google_compute_ha_vpn_gateway.vpn_gateway_1,
google_compute_router.router_name_1,
random_password.vpn_shared_secret,
google_compute_ha_vpn_gateway.vpn_gateway_2,

  ]
}



resource "google_compute_vpn_tunnel" "vpn_tunnel_gw2_if0" {
  name             = var.tunnel_name_gw2_if0
  region           = var.network_region
  project          = google_project.app_dev_project.project_id
  peer_gcp_gateway = google_compute_ha_vpn_gateway.vpn_gateway_1.id

  shared_secret = random_password.vpn_shared_secret.result

  vpn_gateway = google_compute_ha_vpn_gateway.vpn_gateway_2.id
  router      = google_compute_router.router_name_2.id

  vpn_gateway_interface = 0

  ike_version = 2

     depends_on = [
google_compute_router.router_name_2,
google_compute_ha_vpn_gateway.vpn_gateway_2,
google_compute_ha_vpn_gateway.vpn_gateway_1,
random_password.vpn_shared_secret,
  ]
}





resource "google_compute_vpn_tunnel" "vpn_tunnel_gw2_if1" {
  name             = var.tunnel_name_gw2_if1
  region           = var.network_region
  project          = google_project.app_dev_project.project_id
  peer_gcp_gateway = google_compute_ha_vpn_gateway.vpn_gateway_1.id

  shared_secret = random_password.vpn_shared_secret.result

  vpn_gateway = google_compute_ha_vpn_gateway.vpn_gateway_2.id
  router      = google_compute_router.router_name_2.id

  vpn_gateway_interface = 1

  ike_version = 2

     depends_on = [
        google_compute_router.router_name_2,
google_compute_ha_vpn_gateway.vpn_gateway_2,
google_compute_ha_vpn_gateway.vpn_gateway_1,
random_password.vpn_shared_secret,
  ]
}




resource "google_compute_router_interface" "router_1_interface_0" {
  name    = var.router_1_interface_name_0
  router  = google_compute_router.router_name_1.name
  region  = var.network_region
  project = google_project.app_dev_project.project_id

  vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel_gw1_if0.name

  ip_range = "${var.ip_address_1}/${var.mask_length}"

     depends_on = [
google_compute_vpn_tunnel.vpn_tunnel_gw1_if0,
google_compute_router.router_name_1,
  ]

}




resource "google_compute_router_peer" "router_1_peer_gw1_if0" {
  name            = var.peer_name_gw1_if0
  project         = google_project.app_dev_project.project_id
  router          = google_compute_router.router_name_1.name
  region          = var.network_region
  peer_ip_address = var.ip_address_3
  peer_asn        = var.peer_asn_2
  interface       = google_compute_router_interface.router_1_interface_0.name

  advertised_ip_ranges {
    range = "${var.private_pool_network}/${var.private_pool_prefix}"
  }
  advertise_mode = "CUSTOM"

     depends_on = [
google_compute_router_interface.router_1_interface_0,
google_compute_router.router_name_1,
  ]

}




resource "google_compute_router_interface" "router_1_interface_1" {
  name    = var.router_1_interface_name_1
  project = google_project.app_dev_project.project_id
  router  = google_compute_router.router_name_1.name
  region  = var.network_region

  vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel_gw1_if1.name

  ip_range = "${var.ip_address_2}/${var.mask_length}"
   depends_on = [
google_compute_vpn_tunnel.vpn_tunnel_gw1_if1,
google_compute_router.router_name_1,
  ]


}




resource "google_compute_router_peer" "router_1_peer_gw1_if1" {
  name            = var.peer_name_gw1_if1
  project         = google_project.app_dev_project.project_id
  router          = google_compute_router.router_name_1.name
  region          = var.network_region
  peer_ip_address = var.ip_address_4
  peer_asn        = var.peer_asn_2
  interface       = google_compute_router_interface.router_1_interface_1.name
  advertised_ip_ranges {
    range = "${var.private_pool_network}/${var.private_pool_prefix}"
  }
  advertise_mode = "CUSTOM"

     depends_on = [
google_compute_router_interface.router_1_interface_1,
google_compute_router.router_name_1,
  ]
}




resource "google_compute_router_interface" "router_2_interface_0" {
  name    = var.router_2_interface_name_0
  project = google_project.app_dev_project.project_id
  router  = google_compute_router.router_name_2.name
  region  = var.network_region

  vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel_gw2_if0.name

  ip_range = "${var.ip_address_3}/${var.mask_length}"

     depends_on = [
google_compute_vpn_tunnel.vpn_tunnel_gw2_if0,
google_compute_router.router_name_2,
  ]

}




resource "google_compute_router_peer" "router_2_peer_gw2_if0" {
  name            = var.peer_name_gw2_if0
  project         = google_project.app_dev_project.project_id
  router          = google_compute_router.router_name_2.name
  region          = var.network_region
  peer_ip_address = var.ip_address_1
  peer_asn        = var.peer_asn_1
  interface       = google_compute_router_interface.router_2_interface_0.name
  advertised_ip_ranges {
    range = var.gke_subnetwork_master_cidr_range
  }
  advertise_mode = "CUSTOM"

     depends_on = [
google_compute_router_interface.router_2_interface_0,
google_compute_router.router_name_2,
  ]
}




resource "google_compute_router_interface" "router_2_interface_1" {
  name    = var.router_2_interface_name_1
  project = google_project.app_dev_project.project_id
  router  = google_compute_router.router_name_2.name
  region  = var.network_region

  vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel_gw2_if1.name

  ip_range = "${var.ip_address_4}/${var.mask_length}"
     depends_on = [
google_compute_router.router_name_2,
google_compute_vpn_tunnel.vpn_tunnel_gw2_if1,
  ]

}



resource "google_compute_router_peer" "router_2_peer_gw2_if1" {
  name            = var.peer_name_gw2_if1
  project         = google_project.app_dev_project.project_id
  router          = google_compute_router.router_name_2.name
  region          = var.network_region
  peer_ip_address = var.ip_address_2
  peer_asn        = var.peer_asn_1
  interface       = google_compute_router_interface.router_2_interface_1.name
  advertised_ip_ranges {
    range = var.gke_subnetwork_master_cidr_range
  }
  advertise_mode = "CUSTOM"
     depends_on = [
google_compute_router_interface.router_2_interface_1,
google_compute_router.router_name_2,
  ]
}
