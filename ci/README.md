# CI for Terraform

This cloudbuild.yaml configuration is intended to service a Continuous Integration (CI) for this project. The pipline validates that the Terraform can apply cleanly on a fresh project. This cloudbuild.yaml file is not intended for use in the secure app developement Cloud Workstation environment, and is not part of the 'java-sample-app' project.

## Submit a build manually

```
# cd to the directory that contains the base directory for this repository
# fill in the substitution vars with their correct values
gcloud builds submit . \
  --region=us-central1 \
  --config=ci/cloudbuild.yaml \
  --substitutions=\
_ORGANIZATION_ID="",\
_BILLING_ACCOUNT="",\
_END_USER_ACCCOUNT="",\
_TEST_PROJECT_NAME="",\
_TEST_FOLDER_NAME=""
```

## Create a Trigger
TODO
