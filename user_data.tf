# use instead user_data to be pass on to instances
# cloud_init will execute the template

data "template_file" "coreOS" {
  template = "${file("templates/python_coreos.tpl")}"

  vars {
    VERSION = "2.7.13.2715"
    PACKAGE = "ActivePython-2.7.13.2715-linux-x86_64-glibc-2.12-402695"
  }
}

data "template_file" "centos" {
  template = "${file("templates/centos_install_docker.tpl")}"
}
