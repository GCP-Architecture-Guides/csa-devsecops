# Changelog

All notable changes to the **CSA DevSecOps Demo Environment** repository during this modernization cycle are documented below.

## [1.1.0] - 2024-11-20

### Added
- **Native Terraform Cloud Deploy Pipeline and Targets:**
  - Added `app-dev/clouddeploy.tf` declaring `google_clouddeploy_delivery_pipeline` and `google_clouddeploy_target` natively.
  - Eliminated the requirement to invoke the external `gcloud deploy apply` CLI command inside the workstation initialization pipeline, improving deployment reliability and state management.
- **Improved Dependency Orchestration:**
  - Standardized `depends_on` hooks across IAM bindings, GKE clusters, Cloud Workstation clusters, and KMS modules to prevent timing conflicts.
  - Coupled key management dependencies to wait until project-level APIs and organizational policies are fully propagated.

### Changed
- **KMS Configuration Refactoring:**
  - Removed duplicate and circular self-referencing definitions on the `google_kms_crypto_key.signing_key` lifecycle block.
  - Disabled the destructive recreation-triggering `protection_level` block template in favor of clean updates, resolving state reconciliation failures.
- **Code Standardizations and Formatting:**
  - Ran `terraform fmt` across all modified module templates for clean spacing, alignment, and modern style conformity.
- **Enterprise-ready Licensing & Disclaimers:**
  - Appended Apache 2.0 copyright headers and PoC disclaimers to critical template files.
  - Safeguarded standard workspace directories with appropriate root licensing frameworks.

### Fixed
- Resolved validation syntax crashes originating from invalid interpolation variables within the Cloud Build and Binary Authorization profiles.
