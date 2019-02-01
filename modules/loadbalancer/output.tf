# show vip address
output "vip_port_address" {
  value = "${openstack_networking_floatingip_v2.lb_floatingip.address}"
}
