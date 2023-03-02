# Copyright (c) 2020, 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# Create namespace deviceapi for the deviceapi microservices
resource "kubernetes_namespace" "deviceapi_namespace" {
  metadata {
    name = "deviceapi"
  }
  
  depends_on = [module.oci-oke.oci_oke_node_pool]
}

# Deploy deviceapi chart
resource "helm_release" "deviceapi" {
  name      = "deviceapi"
  chart     = "../helm-chart/deviceapi"
  namespace = kubernetes_namespace.deviceapi_namespace.id
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

  timeout = 500
}
