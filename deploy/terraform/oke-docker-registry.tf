##################################################
###     Secret for OCI docker image access     ###
##################################################

resource "kubernetes_secret" "docker-registry" {
  metadata {
    name      = var.docker_registry_name
    namespace = kubernetes_namespace.mydemoapp_namespace.id
  }
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.docker_registry_server}" = {
          "username" = var.docker_registry_username
          "password" = var.docker_registry_password
          "email"    = var.docker_registry_email
          "auth"     = base64encode("${var.docker_registry_username}:${var.docker_registry_password}")
        }
      }
    })
  }
  type = "kubernetes.io/dockerconfigjson"
  depends_on = [module.oci-oke.oci_oke_node_pool]
}
