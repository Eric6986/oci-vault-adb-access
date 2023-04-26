# Copyright (c) 2020-2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# Create namespace mydemoapp-utilities for supporting services
resource "kubernetes_namespace" "cluster_utilities_namespace" {
  metadata {
    name = "mydemoapp-utilities"
  }
  depends_on = [oci_containerengine_node_pool.oke_node_pool]
}

# mydemoapp Utilities helm charts

## https://kubernetes.github.io/ingress-nginx/
## https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx
resource "helm_release" "ingress_nginx" {
  name       = "mydemoapp-utils-ingress-nginx" # mydemoapp-utils included to be backwards compatible to the docs and setup chart install
  repository = local.helm_repository.ingress_nginx
  chart      = "ingress-nginx"
  version    = "4.6.0"
  namespace  = kubernetes_namespace.cluster_utilities_namespace.id
  wait       = true

  set {
    name  = "controller.metrics.enabled"
    value = true
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/oci-load-balancer-shape"
    value = var.ingress_load_balancer_shape
    type  = "string"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/oci-load-balancer-shape-flex-min"
    value = var.ingress_load_balancer_shape_flex_min
    type  = "string"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/oci-load-balancer-shape-flex-max"
    value = var.ingress_load_balancer_shape_flex_max
    type  = "string"
  }

  timeout = 1800 # workaround to wait the node be active for other charts
  depends_on = [oci_containerengine_node_pool.oke_node_pool]
}

## https://github.com/jetstack/cert-manager/blob/master/README.md
## https://artifacthub.io/packages/helm/cert-manager/cert-manager
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = local.helm_repository.jetstack
  chart      = "cert-manager"
  version    = "1.11.1"
  namespace  = kubernetes_namespace.cluster_utilities_namespace.id
  wait       = true # wait to allow the webhook be properly configured

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "webhook.timeoutSeconds"
    value = "30"
  }
  depends_on = [helm_release.ingress_nginx] # Ugly workaround because of the oci pvc provisioner not be able to wait for the node be active and retry.

}

# mydemoapp Datasources for outputs
## Kubernetes Service: mydemoapp-utils-ingress-nginx-controller
data "kubernetes_service" "mydemoapp_ingress" {
  metadata {
    name      = "mydemoapp-utils-ingress-nginx-controller" # mydemoapp-utils name included to be backwards compatible to the docs and setup chart install
    namespace = kubernetes_namespace.cluster_utilities_namespace.id
  }
  depends_on = [helm_release.ingress_nginx]
}

locals {
  # Helm repos
  helm_repository = {
    ingress_nginx  = "https://kubernetes.github.io/ingress-nginx"
    jetstack       = "https://charts.jetstack.io"                        # cert-manager
  }
}
