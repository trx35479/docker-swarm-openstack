# Expose the private IP of the Instances

output "private_ip" {
  value = "${openstack_compute_instance_v2.compute.*.network.0.fixed_ip_v4}"
}
