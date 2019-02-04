# output

output "fips" {
  value = "${openstack_networking_floatingip_v2.fips.*.address}"
}
