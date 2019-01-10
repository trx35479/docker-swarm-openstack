# Output the network uuid to be used on instantiating compute nodes

output "network_name" {
  value = "${openstack_networking_network_v2.docker-net.name}"
}

output "router_id" {
  value = "${element(concat(openstack_networking_router_v2.docker-rtr.*.id, list("")), 0)}"
}
