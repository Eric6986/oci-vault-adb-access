###################################################
###              Device API setup               ###
###################################################

# Create namespace myDemoApp for the myDemoApp microservices
resource "kubernetes_namespace" "mydemoapp_namespace" {
  metadata {
    name = "mydemoapp-dev"
  }
  
  depends_on = [oci_containerengine_node_pool.oke_node_pool]
}

# Deploy myDemoApp chart
resource "helm_release" "mydemoapp" {
  name      = "mydemoapp"
  chart     = "../helm-chart/myDemoApp"
  namespace = kubernetes_namespace.mydemoapp_namespace.id
  wait      = false

  set {
    name  = "global.oadbAdminSecret"
    value = var.db_admin_name
  }
  set {
    name  = "global.oadbConnectionSecret"
    value = var.db_connection_name
  }
  set {
    name  = "global.oadbWalletSecret"
    value = var.db_wallet_name
  }
  set {
    name  = "deviceapi.secrets.oadbUserSecret"
    value = var.db_deviceapi_name
  }
  set {
    name  = "ingress.enabled"
    value = var.ingress_nginx_enabled
  }
  set {
    name  = "ingress.hosts"
    value = "{${var.ingress_hosts}}"
  }
  set {
    name  = "ingress.clusterIssuer"
    value = var.cert_manager_enabled ? var.ingress_cluster_issuer : ""
  }
  set {
    name  = "ingress.email"
    value = var.ingress_email_issuer
  }
  set {
    name  = "ingress.tls"
    value = var.ingress_tls
  }
  
  timeout = 500
  depends_on = [helm_release.ingress_nginx, helm_release.cert_manager]
}

# Generate spring boot configuration file
data "local_file" "api_config_template" {
    filename = "../helm-chart/myDemoApp/charts/deviceapi/config/application-template.yml"
}

resource "local_file" "dev_config_generate" {
  content  = join("\n", [
  for line in split("\n", data.local_file.api_config_template.content) : 
  (
    length(regexall("{oadbService}", line)) > 0 ? replace(line, "{oadbService}", "ocivaultdemo${random_string.deploy_id.result}_tp") : 
      (length(regexall("{ociRegion}", line)) > 0 ? replace(line, "{ociRegion}", "${var.region}") :
        (length(regexall("{adbUsername}", line)) > 0 ? replace(line, "{adbUsername}", "${oci_vault_secret.oci_vault_secret_adb_deviceapi_username.id}") :
          (length(regexall("{adbPassword}", line)) > 0 ? replace(line, "{adbPassword}", "${oci_vault_secret.oci_vault_secret_adb_deviceapi_password.id}") : line)
        )
      )
  )  
  ])
  filename = "../helm-chart/myDemoApp/charts/deviceapi/config/application-dev.yml"
}
