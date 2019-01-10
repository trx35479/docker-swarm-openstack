# Template to generate dynamic IP address of nodes

data "template_file" "dynamic_inventory" {
  template = "${file("templates/inventory.tpl")}"

  depends_on = [
    "module.fips",
    "module.network",
    "module.compute",
  ]

  vars {
    manager          = "${module.fips.manager_fips}"
    standby-managers = "${join("\n", module.fips.standby_fips)}"
    workers          = "${join("\n", module.fips.worker_fips)}"
  }
}

resource "null_resource" "trigger" {
  triggers {
    template_rendered = "${data.template_file.dynamic_inventory.rendered}"
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.dynamic_inventory.rendered}' > inventory/inventory"
  }
}
