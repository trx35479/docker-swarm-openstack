# Expose the private IP of the Instances

output "manager_private_ip" {
  value = "${openstack_compute_instance_v2.manager.network.0.fixed_ip_v4}"
}

output "standby_private_ips" {
  value = "${openstack_compute_instance_v2.standby-manager.*.network.0.fixed_ip_v4}"
}

output "worker_private_ips" {
  value = "${openstack_compute_instance_v2.worker.*.network.0.fixed_ip_v4}"
}
