output "secgroups" {
  value = ["${openstack_networking_secgroup_v2.inter-secgroup.name}", "${openstack_networking_secgroup_v2.ext-secgroup.name}"]
}

output "ext_secgroup_id" {
  value = "${openstack_networking_secgroup_v2.ext-secgroup.id}"
}
