# Floating IP to be attach on each instances
resource "null_resource" "dummy_dependency" {
  triggers {
    dependency_id = "${var.ROUTER_ID}"
  }
}

resource "openstack_networking_floatingip_v2" "manager" {
  pool       = "${var.PUBLIC_NET}"
  depends_on = ["null_resource.dummy_dependency"]
}

resource "openstack_networking_floatingip_v2" "standby-manager" {
  pool       = "${var.PUBLIC_NET}"
  count      = "${var.NUMBER_OF_MANAGER}"
  depends_on = ["null_resource.dummy_dependency"]
}

resource "openstack_networking_floatingip_v2" "worker" {
  pool       = "${var.PUBLIC_NET}"
  count      = "${var.NUMBER_OF_WORKERS}"
  depends_on = ["null_resource.dummy_dependency"]
}
