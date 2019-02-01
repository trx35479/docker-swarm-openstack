# Instantiate modules
provider "openstack" {}

data "openstack_images_image_v2" "coreos" {
  name = "${var.IMAGE_NAME}"
}

data "openstack_compute_flavor_v2" "flavor" {
  name = "${var.FLAVOR}"
}

resource "openstack_compute_keypair_v2" "mykeypair" {
  name       = "${var.CLUSTER_NAME}-mykeypair"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

locals {
  centos    = "${data.template_file.centos.rendered}"
  coreOS    = "${data.template_file.coreOS.rendered}"
  USER_DATA = "${var.IMAGE_NAME == "coreOS" ? local.coreOS: local.centos}"
}

module "network" {
  source = "modules/network"

  CLUSTER_NAME = "${var.CLUSTER_NAME}"
  NETWORK_CIDR = "10.212.21.0/24"
  PUBLIC_NET   = "${var.PUBLIC_NET}"
  DNS_SERVERS  = ["192.168.11.38", "192.168.11.2", "192.168.0.147"]
}

module "secgroups" {
  source = "modules/secgroups"

  SEC_NAME   = "${var.CLUSTER_NAME}"
  PORT_RANGE = ["22", "80", "8080", "3000"]
}

module "fips" {
  source = "modules/fips"

  PUBLIC_NET        = "${var.PUBLIC_NET}"
  NUMBER_OF_MASTER  = 1
  NUMBER_OF_WORKERS = 3
  NUMBER_OF_MANAGER = 2
  ROUTER_ID         = "${module.network.router_id}"
}

module "manager" {
  source = "modules/compute"

  CLUSTER_NAME    = "${var.CLUSTER_NAME}"
  CLUSTER_ROLE    = "manager"
  KEYPAIR         = "${openstack_compute_keypair_v2.mykeypair.id}"
  IMAGE_ID        = "${data.openstack_images_image_v2.coreos.id}"
  FLAVOR          = "${data.openstack_compute_flavor_v2.flavor.id}"
  COUNT           = ["true", 1]
  NETWORK_NAME    = "${module.network.network_name}"
  SECURITY_GROUPS = "${module.secgroups.secgroups}"
  FIPS            = "${module.fips.manager_fips}"
  USER_DATA       = "${local.USER_DATA}"
  ROUTER_ID       = "${module.network.router_id}"
}

module "standby" {
  source = "modules/compute"

  CLUSTER_NAME    = "${var.CLUSTER_NAME}"
  CLUSTER_ROLE    = "standby"
  KEYPAIR         = "${openstack_compute_keypair_v2.mykeypair.id}"
  IMAGE_ID        = "${data.openstack_images_image_v2.coreos.id}"
  FLAVOR          = "${data.openstack_compute_flavor_v2.flavor.id}"
  COUNT           = ["true", 2]
  NETWORK_NAME    = "${module.network.network_name}"
  SECURITY_GROUPS = "${module.secgroups.secgroups}"
  FIPS            = "${module.fips.standby_fips}"
  USER_DATA       = "${local.USER_DATA}"
  ROUTER_ID       = "${module.network.router_id}"
}

module "worker" {
  source = "modules/compute"

  CLUSTER_NAME    = "${var.CLUSTER_NAME}"
  CLUSTER_ROLE    = "worker"
  KEYPAIR         = "${openstack_compute_keypair_v2.mykeypair.id}"
  IMAGE_ID        = "${data.openstack_images_image_v2.coreos.id}"
  FLAVOR          = "${data.openstack_compute_flavor_v2.flavor.id}"
  COUNT           = ["true", 3]
  NETWORK_NAME    = "${module.network.network_name}"
  SECURITY_GROUPS = "${module.secgroups.secgroups}"
  FIPS            = "${module.fips.worker_fips}"
  USER_DATA       = "${local.USER_DATA}"
  ROUTER_ID       = "${module.network.router_id}"
}

module "loadbalancer" {
  source = "modules/loadbalancer"

  CLUSTER_NAME    = "${var.CLUSTER_NAME}"
  VIP_NETWORK     = "${var.PUBLIC_NET}"
  SUBNET_ID       = "${module.network.subnet_id}"
  SECURITY_GROUPS = ["${module.secgroups.ext_secgroup_id}"]
  COUNT           = 6
  NODES           = ["${module.manager.private_ip}", "${module.standby.private_ip}", "${module.worker.private_ip}"]
  PROTOCOL        = "HTTP"
  PROTOCOL_PORT   = 3000
  MONITOR_TYPE    = "PING"
  ROUTER_ID       = "${module.network.router_id}"
}

output "manager_fip" {
  value = "${module.fips.manager_fips}"
}

output "standby_manager_fips" {
  value = "${module.fips.standby_fips}"
}

output "worker_fips" {
  value = "${module.fips.worker_fips}"
}

output "loadbalancer_ip" {
  value = "${module.loadbalancer.vip_port_address}"
}
