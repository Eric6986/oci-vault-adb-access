##################################################
###                 OKE output                 ###
##################################################

### Important Security Notice ###
# The private key generated by this resource will be stored unencrypted in your Terraform state file. 
# Use of this resource for production deployments is not recommended. 
# Instead, generate a private key file outside of Terraform and distribute it securely to the system where Terraform will be run.
output "generated_private_key_pem" {
  sensitive = true
  value = var.generate_public_ssh_key ? tls_private_key.oke_worker_node_ssh_key.private_key_pem : "No Keys Auto Generated"
}
output "dev" {
  value = "Made with \u2764 by Oracle Developers"
}
output "comments" {
  value = "The application URL will be unavailable for a few minutes after provisioning while the application is configured and deployed to Kubernetes"
}
output "deploy_id" {
  value = random_string.deploy_id.result
}
output "deployed_to_region" {
  value = var.region
}
output "deployed_oke_kubernetes_version" {
  value = (var.k8s_version == "Latest") ? local.cluster_k8s_latest_version : var.k8s_version
}
output "kubeconfig_for_kubectl" {
  value       = "export KUBECONFIG=./generated/kubeconfig"
  description = "If using Terraform locally, this command set KUBECONFIG environment variable to run kubectl locally"
}

#output "LB_IP" {
#  value = data.oci_load_balancer_load_balancers.LBs.load_balancers[0].ip_addresses
#}

output "REGION" {
  value = var.region
  description = "The OKE deployed region."
}

output "COMPARTMENT_NAME" {
  value = var.compartment_ocid
  description = "The resource compartment ocid."
}

output "K8S_CLUSTER_NAME" {
  value = "oci-vault-k8s-demo-${random_string.deploy_id.result}"
  description = "The target oke cluster name."
}

output "PUBLIC_SVC_SUBNET_NAME" {
  value = oci_core_subnet.oke_lb_subnet.display_name
  description = "Kubernetes service network name."
}

##################################################
###                 OCI output                 ###
##################################################

output "ADB_NAME" {
  value = oci_database_autonomous_database.adb_ocivaultdemo.display_name
  description = "Autonomous database name."
}

output "VAULT_USER_NAME" {
  value = oci_vault_secret.oci_vault_secret_adb_deviceapi_username.secret_name
  description = "OCI Vault autonomous database secret username."
}

output "VAULT_PWD_NAME" {
  value = oci_vault_secret.oci_vault_secret_adb_deviceapi_password.secret_name
  description = "OCI Vault autonomous database secret password."
}

output "DOCKER_URL" {
  value = var.docker_registry_server
  description = "OCI Singapore docker io."
}

output "autonomous_database_admin_password" {
  value     = random_string.adb_admin_password.result
  sensitive = false
}

output "autonomous_database_deviceapi_password" {
  value     = random_string.adb_deviceapi_password.result
  sensitive = false
}