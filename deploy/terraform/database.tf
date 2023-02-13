resource "oci_database_autonomous_database" "adb_ocivaultdemo" {
  #admin_password = base64decode(data.oci_secrets_secretbundle.adb_admin_password.secret_bundle_content.0.content)
  admin_password             = random_string.adb_admin_password.result
  autonomous_maintenance_schedule_type = "REGULAR"
  customer_contacts {
    email = var.adb_customer_contacts_email
  }
  compartment_id             = var.compartment_ocid
  cpu_core_count             = var.adb_cpu_core_count
  data_safe_status           = "NOT_REGISTERED"
  data_storage_size_in_gb    = var.adb_data_storage_size_in_gb
  data_storage_size_in_tbs   = "1"
  database_edition           = ""
  database_management_status = ""
  db_name                    = var.adb_display_name
  db_version                 = var.adb_db_version
  db_workload                = var.adb_db_workload
  display_name               = var.adb_display_name
  is_auto_scaling_enabled             = "true"
  is_auto_scaling_for_storage_enabled = "true"
  is_data_guard_enabled               = "false"
  is_dedicated                        = "false"
  is_free_tier                        = "false"
  is_local_data_guard_enabled         = "false"
  is_mtls_connection_required         = "false"
  license_model      = "LICENSE_INCLUDED"
  open_mode                  = "READ_WRITE"
  operations_insights_status = "NOT_ENABLED"
  permission_level           = "UNRESTRICTED"
  subnet_id = oci_core_subnet.oke_nodes_subnet[0].id
}