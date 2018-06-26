# GitLab CI 服务器的搭建

GitLab CI服务器最好是单独与gitlab服务器的一台Linux机器。

## 1. 登录gitlab-ci

```
vagrant ssh gitlab-ci
```

## 2. 安装Docker

docker安装参照[https://docs.docker.com/install/linux/docker-ce/centos/#uninstall-old-versions](https://docs.docker.com/install/linux/docker-ce/centos/#uninstall-old-versions)

### 2.1 安装docker相关依赖

```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

### 2.2 由于网速慢使用阿里云docker源

```
sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl start docker
```

### 2.3 配置 Docker 加速器

参照[https://www.daocloud.io/mirror#accelerator-doc](https://www.daocloud.io/mirror#accelerator-doc)

```
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f741ab79.m.daocloud.io
sudo systemctl restart docker
```

以上docker安装步骤集成在labs/scripts/docker.sh文件中

## 3. 安装gitlab ci runner

具体安装参照[https://docs.gitlab.com/runner/install/linux-manually.html](https://docs.gitlab.com/runner/install/linux-manually.html)

### 3.1 新建 `/etc/yum.repos.d/gitlab-ci-multi-runner.repo`，内容为

```
[gitlab-ci-multi-runner]
name=gitlab-ci-multi-runner
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ci-multi-runner/yum/el7
repo_gpgcheck=0
gpgcheck=0
enabled=1
gpgkey=https://packages.gitlab.com/gpg.key
```

### 3.2 再执行

```
sudo yum makecache
sudo yum install -y gitlab-ci-multi-runner
```

### 3.3 查看是否运行正常

```
[vagrant@gitlab-ci ~]$ sudo gitlab-ci-multi-runner status
gitlab-runner: Service is running!
```

## 4. 设置Docker权限

为了能让gitlab-runner能正确的执行docker命令，需要把gitlab-runner用户添加到docker group里, 然后重启docker和gitlab ci runner

```
[vagrant@gitlab-ci ~]$ sudo usermod -aG docker gitlab-runner
[vagrant@gitlab-ci ~]$ sudo service docker restart
Redirecting to /bin/systemctl restart docker.service
[vagrant@gitlab-ci ~]$ sudo gitlab-ci-multi-runner restart
```

