# output

output "manager_fips" {
  value = "${openstack_networking_floatingip_v2.manager.*.address}"
}

output "standby_fips" {
  value = "${openstack_networking_floatingip_v2.standby-manager.*.address}"
}

output "worker_fips" {
  value = "${openstack_networking_floatingip_v2.worker.*.address}"
}
