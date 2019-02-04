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

module "fip_manager" {
  source = "modules/fips"

  PUBLIC_NET        = "${var.PUBLIC_NET}"
  COUNT             = "${var.NUMBER_OF_MANAGER}"
  ROUTER_ID         = "${module.network.router_id}"
}

module "fip_workers" {
  source = "modules/fips"

  PUBLIC_NET        = "${var.PUBLIC_NET}"
  COUNT             = "${var.NUMBER_OF_WORKERS}"
  ROUTER_ID         = "${module.network.router_id}"
}

module "manager" {
  source = "modules/compute"

  CLUSTER_NAME    = "${var.CLUSTER_NAME}"
  CLUSTER_ROLE    = "manager"
  KEYPAIR         = "${openstack_compute_keypair_v2.mykeypair.id}"
  IMAGE_ID        = "${data.openstack_images_image_v2.coreos.id}"
  FLAVOR          = "${data.openstack_compute_flavor_v2.flavor.id}"
  COUNT           = ["true", "${var.NUMBER_OF_MANAGER}"]
  NETWORK_NAME    = "${module.network.network_name}"
  SECURITY_GROUPS = "${module.secgroups.secgroups}"
  FIPS            = "${module.fip_manager.fips}"
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
  COUNT           = ["true", "${var.NUMBER_OF_WORKERS}"]
  NETWORK_NAME    = "${module.network.network_name}"
  SECURITY_GROUPS = "${module.secgroups.secgroups}"
  FIPS            = "${module.fip_workers.fips}"
  USER_DATA       = "${local.USER_DATA}"
  ROUTER_ID       = "${module.network.router_id}"
}

module "loadbalancer" {
  source = "modules/loadbalancer"

  CLUSTER_NAME    = "${var.CLUSTER_NAME}"
  VIP_NETWORK     = "${var.PUBLIC_NET}"
  SUBNET_ID       = "${module.network.subnet_id}"
  SECURITY_GROUPS = ["${module.secgroups.ext_secgroup_id}"]
  COUNT           = "${var.NUMBER_OF_MANAGER + var.NUMBER_OF_WORKERS}"
  NODES           = ["${module.manager.private_ip}", "${module.worker.private_ip}"]
  PROTOCOL        = "HTTP"
  PROTOCOL_PORT   = 3000
  MONITOR_TYPE    = "PING"
  ROUTER_ID       = "${module.network.router_id}"
}

output "manager_fip" {
  value = "${slice(module.fip_manager.fips, 0, 1)}"
}

output "standby_manager_fips" {
  value = "${slice(module.fip_manager.fips, 1, var.NUMBER_OF_MANAGER)}"
}

output "worker_fips" {
  value = "${module.fip_workers.fips}"
}

output "loadbalancer_ip" {
  value = "${module.loadbalancer.vip_port_address}"
}
