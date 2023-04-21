#################################################
###                    KMS                    ###
#################################################

# Create vault to store the serivce adb username and password
resource "oci_kms_vault" "oci_vault" {
  compartment_id             = var.compartment_ocid
  display_name               = "oci-vault-${random_string.deploy_id.result}"
  vault_type                 = "DEFAULT"
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_kms_key" "oci_vault_encryption_key" {
  compartment_id             = var.compartment_ocid
  desired_state              = "ENABLED"
  display_name               = "oci-vault-encryption-key-${random_string.deploy_id.result}"
  key_shape {
    algorithm                = "AES"
    curve_id                 = ""
    length                   = "32"
  }
  management_endpoint        = oci_kms_vault.oci_vault.management_endpoint
  protection_mode            = "SOFTWARE"
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_kms_key_version" "oci_vault_encryption_key_version" {
  management_endpoint        = oci_kms_vault.oci_vault.management_endpoint
  key_id                     = oci_kms_key.oci_vault_encryption_key.id
}