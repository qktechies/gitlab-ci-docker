#/bin/bash

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# 修改docker安装源
sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl start docker

# 修改docker镜像源
sudo curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f741ab79.m.daocloud.io
sudo systemctl restart docker