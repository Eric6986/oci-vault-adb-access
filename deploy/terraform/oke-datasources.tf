# Copyright (c) 2020-2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# Gets kubeconfig
data "oci_containerengine_cluster_kube_config" "oke" {
  cluster_id = var.create_new_oke_cluster ? module.oci-oke[0].cluster.id : var.existent_oke_cluster_id

  depends_on = [module.oci-oke.oci_containerengine_node_pool]
}
