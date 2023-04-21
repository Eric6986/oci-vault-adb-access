##################################################
###                 OCI Policy                 ###
##################################################

resource "oci_identity_dynamic_group" "oke_nodes_dg" {
  name           = "oke-cluster-dg-${random_string.deploy_id.result}"
  description    = "Cluster Dynamic Group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ANY {ALL {instance.compartment.id = '${var.compartment_ocid}'},ALL {resource.type = 'cluster', resource.compartment.id = '${var.compartment_ocid}'}}"

  provider = oci.home_region
}

resource "oci_identity_policy" "oke_compartment_policies" {
  name           = "oke-cluster-compartment-policies-${random_string.deploy_id.result}"
  description    = "OKE Cluster Compartment Policies"
  compartment_id = var.compartment_ocid
  statements     = local.oke_compartment_statements

  depends_on = [oci_identity_dynamic_group.oke_nodes_dg]

  provider = oci.home_region
}

resource "oci_identity_policy" "oke_tenancy_policies" {
  name           = "oke-cluster-tenancy-policies-${random_string.deploy_id.result}"
  description    = "OKE Cluster Tenancy Policies"
  compartment_id = var.tenancy_ocid
  statements     = local.oke_tenancy_statements

  depends_on = [oci_identity_dynamic_group.oke_nodes_dg]

  provider = oci.home_region
}

locals {
  oke_tenancy_statements = concat(
    local.oci_grafana_metrics_statements
  )
  oke_compartment_statements = concat(
    local.oci_grafana_logs_statements,
    local.allow_oke_use_oci_vault_keys_statements
  )
}

locals {
  oke_nodes_dg  = oci_identity_dynamic_group.oke_nodes_dg.name
  oci_grafana_metrics_statements = [
    "Allow dynamic-group ${local.oke_nodes_dg} to read metrics in tenancy",
    "Allow dynamic-group ${local.oke_nodes_dg} to read compartments in tenancy"
  ]
  oci_grafana_logs_statements = [
    "Allow dynamic-group ${local.oke_nodes_dg} to read log-groups in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${local.oke_nodes_dg} to read log-content in compartment id ${var.compartment_ocid}"
  ]
  allow_oke_use_oci_vault_keys_statements = [
    "Allow dynamic-group ${local.oke_nodes_dg} use vaults in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${local.oke_nodes_dg} use keys in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${local.oke_nodes_dg} use secret-family in compartment id ${var.compartment_ocid}"
  ]
}