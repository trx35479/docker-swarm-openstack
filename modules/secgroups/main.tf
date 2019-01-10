# Security groups that can be attach to instances

resource "openstack_networking_secgroup_v2" "inter-secgroup" {
  name        = "${var.SEC_NAME}-inter-secgroup"
  description = "${var.SEC_NAME} inter-instances security"
}

resource "openstack_networking_secgroup_rule_v2" "inter-secgroup-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = "${openstack_networking_secgroup_v2.inter-secgroup.id}"
  security_group_id = "${openstack_networking_secgroup_v2.inter-secgroup.id}"
}

resource "openstack_networking_secgroup_v2" "ext-secgroup" {
  name        = "${var.SEC_NAME}-ext-secgroup"
  description = "${var.SEC_NAME} - external security group"
}

resource "openstack_networking_secgroup_rule_v2" "ext-secgroup-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.ext-secgroup.id}"
}
