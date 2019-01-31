#!/bin/bash

yum install yum-utils -y
yum-config-manager --enable extras
yum install device-mapper-persistent-data lvm2 -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y

systemctl start docker
usermod -aG docker centos
systemctl restart docker
