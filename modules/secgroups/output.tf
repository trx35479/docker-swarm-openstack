output "int-secgroup" {
  value = "${openstack_networking_secgroup_v2.inter-secgroup.name}"
}

output "ext-secgroup" {
  value = "${openstack_networking_secgroup_v2.ext-secgroup.name}"
}
