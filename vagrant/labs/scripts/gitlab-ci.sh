#!/bin/bash

# 国外安装方式
#curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.rpm.sh | sudo bash

#sudo yum install gitlab-ci-multi-runner -y

# 国内使用清华大学源
sudo rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/gitlab-ci-multi-runner/yum/el7/gitlab-ci-multi-runner-9.5.1-1.x86_64.rpm

sudo usermod -aG docker gitlab-runner
sudo service docker restart
sudo gitlab-ci-multi-runner restart