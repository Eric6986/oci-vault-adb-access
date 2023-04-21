#################################################
###                Kube Config                ###
#################################################

# Gets kubeconfig
data "oci_containerengine_cluster_kube_config" "oke" {
  cluster_id = var.create_new_oke_cluster ? module.oci-oke[0].cluster.id : var.existent_oke_cluster_id

  depends_on = [module.oci-oke.oci_containerengine_node_pool]
}
