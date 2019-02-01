# Define the loadbalancer of the swarm
resource "null_resource" "check_dependency" {
  triggers {
    dependency_id = "${var.ROUTER_ID}"
  }
}

resource "openstack_lb_loadbalancer_v2" "lb" {
  name               = "${var.CLUSTER_NAME}"
  vip_subnet_id      = "${var.SUBNET_ID}"
  security_group_ids = ["${var.SECURITY_GROUPS}"]

  depends_on = ["null_resource.check_dependency"]
}

resource "openstack_lb_listener_v2" "lb_listener" {
  protocol        = "${var.PROTOCOL}"
  protocol_port   = "${var.PROTOCOL_PORT}"
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.lb.id}"
}

resource "openstack_lb_pool_v2" "lb_pool" {
  protocol    = "${var.PROTOCOL}"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.lb_listener.id}"
}

resource "openstack_lb_member_v2" "lb_member" {
  #count = "${length(var.NODES)}"
  count         = "${var.COUNT}"
  pool_id       = "${openstack_lb_pool_v2.lb_pool.id}"
  address       = "${element(var.NODES, count.index)}"
  protocol_port = "${var.PROTOCOL_PORT}"
  subnet_id     = "${var.SUBNET_ID}"
}

resource "openstack_lb_monitor_v2" "lb_monitor" {
  pool_id     = "${openstack_lb_pool_v2.lb_pool.id}"
  type        = "${var.MONITOR_TYPE}"
  delay       = 20
  timeout     = 10
  max_retries = 5
}

resource "openstack_networking_floatingip_v2" "lb_floatingip" {
  pool    = "${var.VIP_NETWORK}"
  port_id = "${openstack_lb_loadbalancer_v2.lb.vip_port_id }"
}
