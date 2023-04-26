###################################################
###             Autonomous Database             ###
###################################################

### ADB
resource "oci_database_autonomous_database" "adb_ocivaultdemo" {
  admin_password                       = random_string.adb_admin_password.result
  autonomous_maintenance_schedule_type = "REGULAR"
  customer_contacts {
    email                              = var.adb_customer_contacts_email
  }
  compartment_id                       = var.compartment_ocid
  cpu_core_count                       = var.adb_cpu_core_count
  data_safe_status                     = "NOT_REGISTERED"
  data_storage_size_in_gb              = var.adb_data_storage_size_in_gb
  data_storage_size_in_tbs             = "1"
  database_edition                     = ""
  database_management_status           = ""
  db_name                              = "ocivaultdemo${random_string.deploy_id.result}"
  db_version                           = var.adb_db_version
  db_workload                          = var.adb_db_workload
  display_name                         = "ocivaultdemo${random_string.deploy_id.result}"
  is_auto_scaling_enabled              = "true"
  is_auto_scaling_for_storage_enabled  = "true"
  is_data_guard_enabled                = "false"
  is_dedicated                         = "false"
  is_free_tier                         = "false"
  is_local_data_guard_enabled          = "false"
  is_mtls_connection_required          = "false"
  license_model                        = "LICENSE_INCLUDED"
  open_mode                            = "READ_WRITE"
  operations_insights_status           = "NOT_ENABLED"
  permission_level                     = "UNRESTRICTED"
  subnet_id                            = oci_core_subnet.oke_nodes_subnet.id
  defined_tags                         = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

### Wallet
resource "oci_database_autonomous_database_wallet" "autonomous_database_wallet" {
  autonomous_database_id = oci_database_autonomous_database.adb_ocivaultdemo.id
  password               = random_string.adb_wallet_password.result
  generate_type          = var.adb_wallet_generate_type
  base64_encode_content  = true
}

### Secret setting for kubernetes
resource "kubernetes_secret" "oadb-admin" {
  metadata {
    name      = var.db_admin_name
    namespace = kubernetes_namespace.mydemoapp_namespace.id
  }
  data = {
    oadb_admin_pw = random_string.adb_admin_password.result
  }
  type = "Opaque"
}

resource "kubernetes_secret" "oadb-deviceapi" {
  metadata {
    name      = var.db_deviceapi_name
    namespace = kubernetes_namespace.mydemoapp_namespace.id
  }
  data = {
    oadb_user = var.adb_deviceapi_username
    oadb_pw = random_string.adb_deviceapi_password.result
  }
  type = "Opaque"
}

resource "kubernetes_secret" "oadb-connection" {
  metadata {
    name      = var.db_connection_name
    namespace = kubernetes_namespace.mydemoapp_namespace.id
  }
  data = {
    oadb_wallet_pw = random_string.adb_wallet_password.result
    oadb_service   = "ocivaultdemo${random_string.deploy_id.result}_tp"
  }
  type = "Opaque"
}

### OADB Wallet extraction <>
resource "kubernetes_secret" "oadb_wallet_zip" {
  metadata {
    name      = "oadb-wallet-zip"
    namespace = kubernetes_namespace.mydemoapp_namespace.id
  }
  data = {
    wallet = oci_database_autonomous_database_wallet.autonomous_database_wallet.content
  }
  type = "Opaque"
}

resource "kubernetes_cluster_role" "secret_creator" {
  metadata {
    name = "secret-creator"
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["create"]
  }
}

resource "kubernetes_cluster_role_binding" "wallet_extractor_crb" {
  metadata {
    name = "wallet-extractor-crb"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.secret_creator.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = kubernetes_namespace.mydemoapp_namespace.id
  }
}

### Use kubernetes to unzip the wallet file and store in secret.
resource "kubernetes_job" "wallet_extractor_job" {
  metadata {
    name      = "wallet-extractor-job"
    namespace = kubernetes_namespace.mydemoapp_namespace.id
  }
  spec {
    template {
      metadata {}
      spec {
        init_container {
          name    = "wallet-extractor"
          image   = "busybox"
          command = ["/bin/sh", "-c"]
          args    = ["base64 -d /tmp/zip/wallet > /tmp/wallet.zip && unzip /tmp/wallet.zip -d /wallet"]
          volume_mount {
            mount_path = "/tmp/zip"
            name       = "wallet-zip"
            read_only  = true
          }
          volume_mount {
            mount_path = "/wallet"
            name       = "wallet"
          }
        }
        container {
          name    = "wallet-binding"
          image   = "bitnami/kubectl"
          command = ["/bin/sh", "-c"]
          args    = ["kubectl create secret generic oadb-wallet --from-file=/wallet"]
          volume_mount {
            mount_path = "/wallet"
            name       = "wallet"
            read_only  = true
          }
        }
        volume {
          name = "wallet-zip"
          secret {
            secret_name = kubernetes_secret.oadb_wallet_zip.metadata.0.name
          }
        }
        volume {
          name = "wallet"
          empty_dir {}
        }
        restart_policy       = "Never"
      }
    }
    backoff_limit              = 1
    ttl_seconds_after_finished = 120
  }

  depends_on = [helm_release.ingress_nginx]

}
### OADB Wallet extraction </>