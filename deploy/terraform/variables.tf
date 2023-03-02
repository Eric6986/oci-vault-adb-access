## Copyright (c) 2022, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
# variable "user_ocid" {}
# variable "fingerprint" {}
# variable "private_key_path" {}
variable "region" {}

variable "cluster_name" {
  default     = "oci-vault-k8s-demo-dev"
  description = "Application name. Will be used as prefix to identify resources, such as OKE, VCN, DevOps, and others"
}

#variable "oci_username" {}
#variable "oci_user_authtoken" {}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.0.0"
}

####################################################
###            Database service account          ###
####################################################
variable adb_deviceapi_username {
  default = "deviceapi"
  description = "Autonomous database device api service account"
}

variable adb_customer_contacts_email { 
  default = "juneyhsieh@gmail.com"
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

variable adb_display_name {
  default = "ocivaultdemo"
  description = "Autonomous database display name"
}

## Secrets
variable "db_admin_name" {
  default = "oadb-admin"
}
variable "db_connection_name" {
  default = "oadb-connection"
}
variable "db_wallet_name" {
  default = "oadb-wallet"
}

variable "adb_wallet_generate_type" {
  default = "SINGLE"
}
