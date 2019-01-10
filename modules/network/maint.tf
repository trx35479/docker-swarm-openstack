# network module
data "openstack_networking_network_v2" "ext_net" {
  name = "${var.PUBLIC_NET}"
}

resource "openstack_networking_router_v2" "docker-rtr" {
  name                = "${var.CLUSTER_NAME}-rtr"
  external_network_id = "${data.openstack_networking_network_v2.ext_net.id}"
  admin_state_up      = "true"
}

resource "openstack_networking_network_v2" "docker-net" {
  name           = "${var.CLUSTER_NAME}-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "docker-subnet" {
  name            = "${var.CLUSTER_NAME}-subnet"
  network_id      = "${openstack_networking_network_v2.docker-net.id}"
  cidr            = "${var.NETWORK_CIDR}"
  ip_version      = 4
  dns_nameservers = ["${var.DNS_SERVERS}"]
}

resource "openstack_networking_router_interface_v2" "int-1" {
  router_id = "${openstack_networking_router_v2.docker-rtr.id}"
  subnet_id = "${openstack_networking_subnet_v2.docker-subnet.id}"
}
