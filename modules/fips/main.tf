# Floating IP to be attach on each instances
resource "null_resource" "dummy_dependency" {
  triggers {
    dependency_id = "${var.ROUTER_ID}"
  }
}

resource "openstack_networking_floatingip_v2" "fips" {
  pool       = "${var.PUBLIC_NET}"
  count      = "${var.COUNT}"
  depends_on = ["null_resource.dummy_dependency"]
}
