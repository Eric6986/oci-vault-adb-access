#################################################
###                   VAULT                   ###
#################################################
resource "oci_vault_secret" "oci_vault_secret_adb_deviceapi_username" {
  depends_on                 = [ oci_kms_key.oci_vault_encryption_key ]
  compartment_id             = var.compartment_ocid
  description                = "adb-deviceapi-username"
  key_id                     = oci_kms_key.oci_vault_encryption_key.id
  secret_content {
    #Required
    content_type             = "BASE64"
    #Optional
    content                  = base64encode(var.adb_deviceapi_username)
  }
  secret_name                = "adb-deviceapi-username"
  vault_id                   = oci_kms_vault.oci_vault.id

  # Required attributes that were not found in discovery have been added to lifecycle ignore_changes
  # This is done to avoid terraform plan failure for the existing infrastructure
  lifecycle {
    ignore_changes           = [secret_content]
  }
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_vault_secret" "oci_vault_secret_adb_deviceapi_password" {
  depends_on                 = [ oci_kms_key.oci_vault_encryption_key ]
  compartment_id             = var.compartment_ocid
  description                = "adb-deviceapi-password"
  key_id                     = oci_kms_key.oci_vault_encryption_key.id
  secret_content {
    #Required
    content_type             = "BASE64"
    #Optional
    content                  = base64encode(random_string.adb_deviceapi_password.result)
  }
  secret_name                = "adb-deviceapi-password"
  vault_id                   = oci_kms_vault.oci_vault.id

  # Required attributes that were not found in discovery have been added to lifecycle ignore_changes
  # This is done to avoid terraform plan failure for the existing infrastructure
  lifecycle {
    ignore_changes           = [secret_content]
  }
  defined_tags               = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}