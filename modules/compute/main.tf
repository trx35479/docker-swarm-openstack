# Instantiate compute
data "openstack_images_image_v2" "coreos" {
  name = "${var.IMAGE_NAME}"
}

resource "openstack_compute_keypair_v2" "mykeypair" {
  name       = "${var.CLUSTER_NAME}-mykeypair"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "openstack_compute_instance_v2" "manager" {
  name            = "${var.CLUSTER_NAME}-manager"
  image_id        = "${data.openstack_images_image_v2.coreos.id}"
  flavor_id       = "${var.MAN_FLAVOR}"
  key_pair        = "${openstack_compute_keypair_v2.mykeypair.id}"
  security_groups = ["${var.EXT_SEC}", "${var.INT_SEC}"]

  network {
    name = "${var.NETWORK_NAME}"
  }

  metadata {
    depends_on = "${var.ROUTER_ID}"
  }
}

resource "openstack_compute_instance_v2" "standby-manager" {
  name            = "${var.CLUSTER_NAME}-standby-manager-${count.index +1}"
  count           = "${var.NUMBER_OF_MANAGER}"
  image_id        = "${data.openstack_images_image_v2.coreos.id}"
  flavor_id       = "${var.MAN_FLAVOR}"
  key_pair        = "${openstack_compute_keypair_v2.mykeypair.id}"
  security_groups = ["${var.EXT_SEC}", "${var.INT_SEC}"]

  network {
    name = "${var.NETWORK_NAME}"
  }

  metadata {
    depends_on = "${var.ROUTER_ID}"
  }
}

resource "openstack_compute_instance_v2" "worker" {
  name            = "${var.CLUSTER_NAME}-worker-${count.index +1}"
  count           = "${var.NUMBER_OF_WORKERS}"
  image_id        = "${data.openstack_images_image_v2.coreos.id}"
  flavor_id       = "${var.WOR_FLAVOR}"
  key_pair        = "${openstack_compute_keypair_v2.mykeypair.id}"
  security_groups = ["${var.EXT_SEC}", "${var.INT_SEC}"]

  network {
    name = "${var.NETWORK_NAME}"
  }

  metadata {
    depends_on = "${var.ROUTER_ID}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "manager" {
  floating_ip = "${var.MANAGER_FIPS}"
  instance_id = "${openstack_compute_instance_v2.manager.id}"
}

resource "openstack_compute_floatingip_associate_v2" "standby-manager" {
  count       = "${var.NUMBER_OF_MANAGER}"
  floating_ip = "${var.STANDBY_MANAGER_FIPS[count.index]}"
  instance_id = "${element(openstack_compute_instance_v2.standby-manager.*.id, count.index)}"
}

resource "openstack_compute_floatingip_associate_v2" "worker" {
  count       = "${var.NUMBER_OF_WORKERS}"
  floating_ip = "${var.WORKER_FIPS[count.index]}"
  instance_id = "${element(openstack_compute_instance_v2.worker.*.id, count.index)}"
}
