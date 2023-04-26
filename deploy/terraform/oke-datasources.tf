#################################################
###                Kube Config                ###
#################################################

# Gets kubeconfig
data "oci_containerengine_cluster_kube_config" "oke" {
  cluster_id = oci_containerengine_cluster.oke_cluster.id

  depends_on = [oci_containerengine_node_pool.oke_node_pool]
}
