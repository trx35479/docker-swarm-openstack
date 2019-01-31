# Instantiate compute

resource "openstack_compute_instance_v2" "compute" {
  name            = "${var.CLUSTER_NAME}-${var.CLUSTER_ROLE}-${count.index +1}"
  count           = "${element(var.COUNT, 0) == "true" ? element(var.COUNT, 1) : 0}"
  image_id        = "${var.IMAGE_ID}"
  flavor_id       = "${var.FLAVOR}"
  key_pair        = "${var.KEYPAIR}"
  security_groups = ["${var.SECURITY_GROUPS}"]

  network {
    name = "${var.NETWORK_NAME}"
  }

  metadata {
    depends_on = "${var.ROUTER_ID}"
  }

  user_data = "${var.USER_DATA}"
}

resource "openstack_compute_floatingip_associate_v2" "fips" {
  count       = "${element(var.COUNT, 0) == "true" ? element(var.COUNT, 1) : 0}"
  floating_ip = "${var.FIPS[count.index]}"
  instance_id = "${element(openstack_compute_instance_v2.compute.*.id, count.index)}"
}
