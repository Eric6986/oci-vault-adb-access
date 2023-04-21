##################################################
###                  Variable                  ###
##################################################

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
# variable "user_ocid" {}
# variable "fingerprint" {}
# variable "private_key_path" {}
variable "region" {}

#variable "oci_username" {}
#variable "oci_user_authtoken" {}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.0.0"
}

####################################################
###             Database configuration           ###
####################################################
variable adb_deviceapi_username {
  default = "deviceapi"
  description = "Autonomous database device api service account"
}

variable adb_customer_contacts_email { 
  default = "testing@gmail.com"
  description = "Autonomous database contact email"
}

variable adb_cpu_core_count { 
  default = "1"
  description = "Autonomous database CPU"
}

variable adb_data_storage_size_in_gb {
  default = "1024"
  description = "Autonomous database storage"
}

variable adb_db_version {
  default = "19c"
  description = "Autonomous database version"
}

variable adb_db_workload {
  default = "AJD"
  description = "Autonomous database workload type"
}

variable "adb_wallet_generate_type" {
  default = "SINGLE"
}

variable "db_admin_name" {
  default = "oadb-admin"
}
variable "db_deviceapi_name" {
  default = "oadb-deviceapi"
}
variable "db_connection_name" {
  default = "oadb-connection"
}
variable "db_wallet_name" {
  default = "oadb-wallet"
}

####################################################
###              Docker configuration            ###
####################################################
variable "docker_registry_name" {
  default = "docker-registry"
}
# Setup your OCI container registry region server
# Reference the page https://docs.oracle.com/en-us/iaas/Content/Registry/Concepts/registryprerequisites.htm
variable "docker_registry_server" {
  default = "sin.ocir.io"
}
# Setup your OCI user name. Ex: <tenancy-namespace>/oracleidentitycloudservice/<username>
# Reference the page https://docs.oracle.com/en-us/iaas/Content/Functions/Tasks/functionslogintoocir.htm
variable "docker_registry_username" {
  default = "<tenancy-namespace>/oracleidentitycloudservice/<username>"
}
# Setup your access token
# Reference the page https://docs.oracle.com/en-us/iaas/Content/Registry/Tasks/registrygettingauthtoken.htm
variable "docker_registry_password" {
  default = "<password>"
}
# Setup your OCI user account email
variable "docker_registry_email" {
  default = "<username>"
}


####################################################
###                  Load Balance                ###
####################################################

## Ingress/LoadBalancer
variable "ingress_nginx_enabled" {
  default     = true
  description = "Enable Ingress Nginx for Kubernetes Services (This option provision a Load Balancer)"
}
variable "ingress_load_balancer_shape" {
  default     = "flexible" # Flexible, 10Mbps, 100Mbps, 400Mbps or 8000Mps
  description = "Shape that will be included on the Ingress annotation for the OCI Load Balancer creation"
}
variable "ingress_load_balancer_shape_flex_min" {
  default     = "10"
  description = "Enter the minimum size of the flexible shape."
}
variable "ingress_load_balancer_shape_flex_max" {
  default     = "100"
  description = "Enter the maximum size of the flexible shape (Should be bigger than minimum size). The maximum service limit is set by your tenancy limits."
}
variable "ingress_hosts" {
  default     = "www.mydemoapp.com"
  description = "Enter a valid full qualified domain name (FQDN). You will need to map the domain name to the EXTERNAL-IP address on your DNS provider (DNS Registry type - A). If you have multiple domain names, include separated by comma. e.g.: mushop.example.com,catshop.com"
}
variable "cert_manager_enabled" {
  default     = true
  description = "Enable x509 Certificate Management"
}
variable "ingress_tls" {
  default     = true
  description = "If enabled, will generate SSL certificates to enable HTTPS for the ingress using the Certificate Issuer"
}
variable "ingress_cluster_issuer" {
  default     = "letsencrypt-prod"
  description = "Certificate issuer type. Currently supports the free Let's Encrypt and Self-Signed. Only *letsencrypt-prod* generates valid certificates"
}
variable "ingress_email_issuer" {
  default     = "no-reply@mydemoapp.com"
  description = "You must replace this email address with your own. The certificate provider will use this to contact you about expiring certificates, and issues related to your account."
}
