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

#!/bin/bash
set -exu

# The following preconditions MUST be true
# 1) The Cloud Workstation must be running
# 2) The Cloud Source Repository must already exist 

# Set by Terraform, used by envsubst
export PROJECT_ID="$PROJECT_ID"
export REGION="$REGION"
export DELIVERY_PIPELINE_NAME="$DELIVERY_PIPELINE_NAME"
export DOCKER_REPO_NAME="$DOCKER_REPO_NAME"
export PRIVATE_WORKER_POOL="$PRIVATE_WORKER_POOL"
export GKE_CLUSTER_NAME="$GKE_CLUSTER_NAME"
export ATTESTOR_NAME="$ATTESTOR_NAME"
export KMS_KEYRING_NAME="$KMS_KEYRING_NAME"
export KMS_KEY_NAME="$KMS_KEY_NAME"
export KMS_KEY_VERSION="$KMS_KEY_VERSION"
export SERVICE_ACCOUNT="$SERVICE_ACCOUNT"
export USER_SOURCE_REPO_NAME="$USER_SOURCE_REPO_NAME"
export USER_SOURCE_REPO_LOCAL_DIR="$USER_SOURCE_REPO_LOCAL_DIR"

# Set by Terraform, not used by envsubst.
# These next few lines are technically unnecessary, but will cause the program to terminate
# early if the vars are not defined (per the bash -u mode)
CLOUD_WORKSTATION_NAME="$CLOUD_WORKSTATION_NAME"
CLOUD_WORKSTATION_CLUSTER="$CLOUD_WORKSTATION_CLUSTER"
CLOUD_WORKSTATION_CONFIG="$CLOUD_WORKSTATION_CONFIG"

CLOUD_SOURCE_REPOSITORY_DIR="${USER_SOURCE_REPO_LOCAL_DIR}/${USER_SOURCE_REPO_NAME}"

SUDO=""; if [ "${EUID:-0}" != "0" ]; then SUDO="sudo"; fi

if ! command -v jq &> /dev/null
then
  $SUDO apt-get install jq -y -q
fi

# Set programatically for git config
TOKEN=$(curl http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token -H Metadata-Flavor:Google | jq -r '.access_token')
USER_EMAIL=$(curl "https://oauth2.googleapis.com/tokeninfo?access_token=$TOKEN" | jq -r '.email')
USER_NAME=$(echo $USER_EMAIL | cut -d '@' -f1)

# Managed internally
WORKSTATION_USER_HOME="/home/user"
PROJECT_HOME="${WORKSTATION_USER_HOME}/${USER_SOURCE_REPO_NAME}"

WORK_DIR="$(mktemp -d)/${USER_SOURCE_REPO_NAME}"
cp -r java-sample-app "${WORK_DIR}"

# Install 'nc' if it doesn't already exits
if ! command -v nc &> /dev/null
then
  $SUDO apt-get install netcat -y -q
fi

# Don't substitute $PROJECT_ID in cloudbuild.yaml since it's a predefined Cloud Build var
envsubst '$DELIVERY_PIPELINE_NAME $DOCKER_REPO_NAME $PRIVATE_WORKER_POOL $ATTESTOR_NAME $KMS_KEYRING_NAME $KMS_KEY_NAME $KMS_KEY_VERSION $SERVICE_ACCOUNT' < "${WORK_DIR}/cloudbuild.yaml.tmpl" > "${WORK_DIR}/cloudbuild.yaml"
rm "${WORK_DIR}/cloudbuild.yaml.tmpl"

envsubst '$DELIVERY_PIPELINE_NAME $DOCKER_REPO_NAME $PRIVATE_WORKER_POOL $ATTESTOR_NAME $KMS_KEYRING_NAME $KMS_KEY_NAME $KMS_KEY_VERSION $SERVICE_ACCOUNT $PROJECT_ID $REGION $GKE_CLUSTER_NAME' < "${WORK_DIR}/clouddeploy.yml.tmpl" > "${WORK_DIR}/clouddeploy.yml"
rm "${WORK_DIR}/clouddeploy.yml.tmpl"

envsubst '$DOCKER_REPO_NAME $PRIVATE_WORKER_POOL $SERVICE_ACCOUNT' < "${WORK_DIR}/cloudbuild-launcher.yaml.tmpl" > "${WORK_DIR}/cloudbuild-launcher.yaml"
rm "${WORK_DIR}/cloudbuild-launcher.yaml.tmpl"

# commit back changes to the Cloud Source Repository
cp -r "${WORK_DIR}/." "${CLOUD_SOURCE_REPOSITORY_DIR}/"
CURRENT_DIR="$(pwd)"
cd "${CLOUD_SOURCE_REPOSITORY_DIR}"
  if [ -z "$(git config --get user.email)" ]; then
    git config --global user.email "${USER_EMAIL}"
  fi
  if [ -z "$(git config --get user.name)" ]; then
    git config --global user.name "${USER_NAME}"
  fi
  git add .
  git diff-index --quiet HEAD || git commit -m 'first commit'
  git push origin master

  # Create the Cloud Deploy Pipeline
  gcloud deploy apply \
    --file="clouddeploy.yml" \
    --region="${REGION}" \
    --project="${PROJECT_ID}"
cd "${CURRENT_DIR}"

CONFIG_DIR="$(mktemp -d)/conf"

# Configure Maven Settings
M2_USER_HOME_SETTINGS="${WORKSTATION_USER_HOME}/.m2/settings.xml"
mkdir -p ${CONFIG_DIR}/.m2
cp "java-sample-app/config/maven_settings.xml" "${CONFIG_DIR}/.m2/settings.xml"
# Configure inner dev loop process startup script
cp "java-sample-app/config/hello-world-dev-config.sh" "${CONFIG_DIR}/.hello-world-dev-config"

TUNNEL_PORT="43431"

# Configure an alternative port if the default port is already in use
while nc -z localhost $TUNNEL_PORT; do
  TUNNEL_PORT=$((TUNNEL_PORT+1))
done

WORKSTATION_STATUS=$(gcloud workstations describe $CLOUD_WORKSTATION_NAME \
  --project="${PROJECT_ID}" \
  --cluster="${CLOUD_WORKSTATION_CLUSTER}" \
  --config="${CLOUD_WORKSTATION_CONFIG}" \
  --region="${REGION}" \
  --format "value(state)")

if [ ${WORKSTATION_STATUS} != "STATE_RUNNING" ]; then
  echo "Starting Cloud Workstation..."
  gcloud workstations start $CLOUD_WORKSTATION_NAME \
    --project="${PROJECT_ID}" \
    --cluster="${CLOUD_WORKSTATION_CLUSTER}" \
    --config="${CLOUD_WORKSTATION_CONFIG}" \
    --region="${REGION}"
fi

gcloud beta workstations start-tcp-tunnel $CLOUD_WORKSTATION_NAME 22 \
  --project="${PROJECT_ID}" \
  --cluster="${CLOUD_WORKSTATION_CLUSTER}" \
  --config="${CLOUD_WORKSTATION_CONFIG}" \
  --region="${REGION}" \
  --local-host-port="localhost:${TUNNEL_PORT}" &

echo "waiting for tunnel to open.."
echo "jobs debugging: $(jobs -p)"
echo "jobs debugging with tail: $(jobs -p | tail -n1)"
TUNNEL_PID="$(jobs -p | tail -n1)"

while ! nc -z localhost $TUNNEL_PORT; do
  if ! ps -p $TUNNEL_PID; then
    echo "Failed to Open Tunnel.. Exiting installer.sh"
    exit 1
  fi
  sleep 0.1
done
echo "tunnel opened"

CONFIGURE_WORKSTATION_ENV=$(ssh -p $TUNNEL_PORT -o "StrictHostKeyChecking no" "user@localhost" "test -d ${USER_SOURCE_REPO_NAME}; echo \$?")

if [ $CONFIGURE_WORKSTATION_ENV -ne "0" ]; then
  scp -P $TUNNEL_PORT -o "StrictHostKeyChecking no" -r "${CLOUD_SOURCE_REPOSITORY_DIR}" "user@localhost:"
  scp -P $TUNNEL_PORT -o "StrictHostKeyChecking no" -r "${CONFIG_DIR}/.m2" "user@localhost:"
  scp -P $TUNNEL_PORT -o "StrictHostKeyChecking no" "${CONFIG_DIR}/.hello-world-dev-config" "user@localhost:"
  ssh -p $TUNNEL_PORT -o "StrictHostKeyChecking no" "user@localhost" "echo \"source ~/.hello-world-dev-config $SERVICE_ACCOUNT $PROJECT_HOME\" >> ~/.bashrc"
  ssh -p $TUNNEL_PORT -o "StrictHostKeyChecking no" "user@localhost" "git config --global user.email \"${USER_EMAIL}\""
  ssh -p $TUNNEL_PORT -o "StrictHostKeyChecking no" "user@localhost" "git config --global user.name \"${USER_NAME}\""
else
  echo "Skipping Workstation Environment configuration because the Workstation source directory already exists: ~/${USER_SOURCE_REPO_NAME}"
fi

# kill TCP tunnel to Cloud Workstation
kill $TUNNEL_PID 

