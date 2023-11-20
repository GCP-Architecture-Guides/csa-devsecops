


resource "null_resource" "installer" {
  triggers = {
  #  always_run = "${timestamp()}"
  repo_name= "${google_sourcerepo_repository.my-repo.name}"
  PROJECT_ID="${google_project.app_dev_project.project_id}" 
  REGION="${var.network_region}" 
  DELIVERY_PIPELINE_NAME="spring-java-hello-world-pipeline" 
  DOCKER_REPO_NAME="hello-world-docker-repository" 
  PRIVATE_WORKER_POOL="${var.private_pool_name}" 
  GKE_CLUSTER_NAME="${google_container_cluster.hello_world_cluster.name}" 
  ATTESTOR_NAME="${google_binary_authorization_attestor.attestor.name}" 
  KMS_KEYRING_NAME="${google_kms_key_ring.kms_keyring.name}" 
  KMS_KEY_NAME="${google_kms_crypto_key.signing_key.name}" 
  KMS_KEY_VERSION="${var.kms_key_version}" 
  SERVICE_ACCOUNT="${google_service_account.developer_service_account.email}" 
  USER_SOURCE_REPO_NAME="hello-world-java" 
  USER_SOURCE_REPO_LOCAL_DIR="$USER_SOURCE_CLONE_DIR" 
  CLOUD_WORKSTATION_NAME="${google_workstations_workstation.hello_world_workstation.workstation_id}" 
  CLOUD_WORKSTATION_CLUSTER="${google_workstations_workstation_cluster.workstation_cluster.workstation_cluster_id}" 
  CLOUD_WORKSTATION_CONFIG="${google_workstations_workstation_config.workstation_cluster_config.workstation_config_id}"
  }

  provisioner "local-exec" {
    command = <<EOT
USER_SOURCE_CLONE_DIR="$(mktemp -d)"
gcloud source repos clone ${google_sourcerepo_repository.my-repo.name} "$USER_SOURCE_CLONE_DIR/${google_sourcerepo_repository.my-repo.name}" --project=${google_project.app_dev_project.project_id}
PROJECT_ID="${google_project.app_dev_project.project_id}" REGION="${var.network_region}" DELIVERY_PIPELINE_NAME="spring-java-hello-world-pipeline" DOCKER_REPO_NAME="hello-world-docker-repository" PRIVATE_WORKER_POOL="${var.private_pool_name}" GKE_CLUSTER_NAME="${google_container_cluster.hello_world_cluster.name}" ATTESTOR_NAME="${google_binary_authorization_attestor.attestor.name}" KMS_KEYRING_NAME="${google_kms_key_ring.kms_keyring.name}" KMS_KEY_NAME="${google_kms_crypto_key.signing_key.name}" KMS_KEY_VERSION="${var.kms_key_version}" SERVICE_ACCOUNT="${google_service_account.developer_service_account.email}" USER_SOURCE_REPO_NAME="hello-world-java" USER_SOURCE_REPO_LOCAL_DIR="$USER_SOURCE_CLONE_DIR" CLOUD_WORKSTATION_NAME="${google_workstations_workstation.hello_world_workstation.workstation_id}" CLOUD_WORKSTATION_CLUSTER="${google_workstations_workstation_cluster.workstation_cluster.workstation_cluster_id}" CLOUD_WORKSTATION_CONFIG="${google_workstations_workstation_config.workstation_cluster_config.workstation_config_id}" ./installer.sh

       EOT
       interpreter = ["sh", "-c"]
  }

   depends_on = [
    google_sourcerepo_repository.my-repo,
    google_container_cluster.hello_world_cluster,
    google_binary_authorization_attestor.attestor,
    google_kms_key_ring.kms_keyring,
google_kms_crypto_key.signing_key,
    google_service_account.developer_service_account,
    google_workstations_workstation.hello_world_workstation,
 google_workstations_workstation_cluster.workstation_cluster,
        google_workstations_workstation_config.workstation_cluster_config,
        resource.null_resource.start_workstaion,
   ]
}

