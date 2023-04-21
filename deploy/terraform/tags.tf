###################################################
###                     Tag                     ###
###################################################

resource "random_id" "tag" {
  byte_length = 2
}

resource "oci_identity_tag_namespace" "ArchitectureCenterTagNamespace" {
  provider       = oci.home_region
  compartment_id = var.compartment_ocid
  description    = "ArchitectureCenterTagNamespace"
  name           = "ArchitectureCenter\\ci-cd-pipe-oci-devops-${random_id.tag.hex}"

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "oci_identity_tag" "ArchitectureCenterTag" {
  provider         = oci.home_region
  description      = "ArchitectureCenterTag"
  name             = "release"
  tag_namespace_id = oci_identity_tag_namespace.ArchitectureCenterTagNamespace.id

  validator {
    validator_type = "ENUM"
    values         = ["release", "${var.release}"]
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

}
