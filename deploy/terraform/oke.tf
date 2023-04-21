###################################################
###                 OKE Cluster                 ###
###################################################

module "oci-oke" {
  count                                                                       = var.create_new_oke_cluster ? 1 : 0
  source                                                                      = "github.com/oracle-devrel/terraform-oci-arch-oke"
  tenancy_ocid                                                                = var.tenancy_ocid
  compartment_ocid                                                            = var.compartment_ocid
  oke_cluster_name                                                            = "oci-vault-k8s-demo-${random_string.deploy_id.result}"
  services_cidr                                                               = lookup(var.network_cidrs, "KUBERNETES-SERVICE-CIDR")
  pods_cidr                                                                   = lookup(var.network_cidrs, "PODS-CIDR")
  cluster_options_add_ons_is_kubernetes_dashboard_enabled                     = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
  cluster_options_add_ons_is_tiller_enabled                                   = false
  cluster_options_admission_controller_options_is_pod_security_policy_enabled = var.cluster_options_admission_controller_options_is_pod_security_policy_enabled
  pool_name                                                                   = var.node_pool_name
  node_shape                                                                  = var.node_pool_shape
  node_ocpus                                                                  = var.node_pool_node_shape_config_ocpus
  node_memory                                                                 = var.node_pool_node_shape_config_memory_in_gbs
  node_count                                                                  = var.num_pool_workers
  node_pool_boot_volume_size_in_gbs                                           = var.node_pool_boot_volume_size_in_gbs
  k8s_version                                                                 = (var.k8s_version == "Latest") ? local.cluster_k8s_latest_version : var.k8s_version
  use_existing_vcn                                                            = true
  vcn_id                                                                      = oci_core_virtual_network.oke_vcn.id
  is_api_endpoint_subnet_public                                               = (var.cluster_endpoint_visibility == "Private") ? false : true
  api_endpoint_subnet_id                                                      = oci_core_subnet.oke_k8s_endpoint_subnet.id
  api_endpoint_nsg_ids                                                        = []  
  is_lb_subnet_public                                                         = true
  lb_subnet_id                                                                = oci_core_subnet.oke_lb_subnet.id
  is_nodepool_subnet_public                                                   = false
  nodepool_subnet_id                                                          = oci_core_subnet.oke_nodes_subnet.id
  ssh_public_key                                                              = var.generate_public_ssh_key ? tls_private_key.oke_worker_node_ssh_key.public_key_openssh : var.public_ssh_key
  defined_tags                                                                = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

/*
resource "oci_identity_compartment" "oke_compartment" {
  compartment_id = var.compartment_ocid
  name           = "oke-compartment-${random_string.deploy_id.result}"
  description    = "${var.oke_compartment_description} (Deployment ${random_string.deploy_id.result})"
  enable_delete  = true
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }

}
*/

# Local kubeconfig for when using Terraform locally. Not used by Oracle Resource Manager
resource "local_file" "kubeconfig" {
  content  = data.oci_containerengine_cluster_kube_config.oke_cluster_kube_config.content
  filename = "generated/kubeconfig"
}

# Generate ssh keys to access Worker Nodes, if generate_public_ssh_key=true, applies to the pool
resource "tls_private_key" "oke_worker_node_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Get OKE options
locals {
  cluster_k8s_latest_version   = reverse(sort(data.oci_containerengine_cluster_option.oke.kubernetes_versions))[0]
  node_pool_k8s_latest_version = reverse(sort(data.oci_containerengine_node_pool_option.oke.kubernetes_versions))[0]
}

# Checks if is using Flexible Compute Shapes
locals {
  is_flexible_node_shape = contains(local.compute_flexible_shapes, var.node_pool_shape)
}

# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex"
  ]
}