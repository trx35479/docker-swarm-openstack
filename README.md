# docker-swarm-openstack
  - Terraform will be used to build the the swarm infrastructure and populate the ip address to inventory to be used by the Ansible module
  - Ansible will be used to configure docker swarm mode as well as scaling the swarm
  - Option to use CoreOS or CentOS

# To use - modify the variables on the root directory

  - Define your cluster name variable 
      variable "CLUSTER_NAME" 
      default = "dswarm"

  - Define your image name to be used - toogle between CoreOS nad CentOS7
      variable "IMAGE_NAME" 
      default = "coreOS" or
      default = "centos7"

  - Define the flavor of the swarm to be used
      variable "FLAVOR" 
      default = "m1.small"

  - Define the public subnet that swarm will be placed on
      variable "PUBLIC_NET" 
      default = "public"

