## 实际python项目,导入项目

```
https://github.com/imooc-course/docker-cloud-flask-demo
```

## 修改Dockerfile(国外软件仓库安装速度慢)

```
FROM python:2.7.14-alpine

LABEL author="Peng Xiao <xiaoquwl@gmail.com>"

# 修改国内源代码
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache gcc musl-dev openssl-dev libffi-dev
COPY . /skeleton
WORKDIR /skeleton
# 修改python安装源
RUN pip install -r requirements.txt -i https://pypi.mirrors.ustc.edu.cn/simple/ 
EXPOSE 5000
ENTRYPOINT ["sh", "scripts/dev.sh"]

```

## 创建本地镜像

```
docker build -t flask-demo .
```

## 本地启动测试

```
 docker run -d --name flask-demo -p 5000:5000 flask-demo
```

## 本地检查代码风格和测试

```
pip install tox -i https://pypi.mirrors.ustc.edu.cn/simple/
tox -i https://pypi.mirrors.ustc.edu.cn/simple/
```

## 注册一个对应工程的Runner

### python 2.7

```
[vagrant@gitlab-ci scripts]$ sudo gitlab-ci-multi-runner register
Running in system-mode.

Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://gitlab.example.com
Please enter the gitlab-ci token for this runner:
Zxyg8wLQLCgzup-Sa_Qq
Please enter the gitlab-ci description for this runner:
[gitlab-ci]:
Please enter the gitlab-ci tags for this runner (comma separated):
python2.7
Whether to run untagged builds [true/false]:
[false]:
Whether to lock Runner to current project [true/false]:
[false]:
Registering runner... succeeded                     runner=Zxyg8wLQ
Please enter the executor: docker, docker-ssh, parallels, ssh, virtualbox, shell, docker+machine, docker-ssh+machine, kubernetes:
docker
Please enter the default Docker image (e.g. ruby:2.1):
python:2.7
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

### python 3.4

```
[vagrant@gitlab-ci scripts]$ sudo gitlab-ci-multi-runner register
Running in system-mode.

Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://gitlab.example.com
Please enter the gitlab-ci token for this runner:
Zxyg8wLQLCgzup-Sa_Qq
Please enter the gitlab-ci description for this runner:
[gitlab-ci]:
Please enter the gitlab-ci tags for this runner (comma separated):
python3.4
Whether to run untagged builds [true/false]:
[false]:
Whether to lock Runner to current project [true/false]:
[false]:
Registering runner... succeeded                     runner=Zxyg8wLQ
Please enter the executor: docker, shell, ssh, docker-ssh, parallels, virtualbox, docker+machine, docker-ssh+machine, kubernetes:
docker
Please enter the default Docker image (e.g. ruby:2.1):
python:3.4
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

## docker提前拉取python:2.7和python3.4

```
docker pull python:2.7
docker pull python:3.4
```

## 校验Runner是否已经启动

```
[vagrant@gitlab-ci scripts]$ sudo gitlab-ci-multi-runner verify
Running in system-mode.

Verifying runner... is alive                        runner=c47d0a4a
Verifying runner... is alive                        runner=57e0196c
Verifying runner... is alive                        runner=0cfe16ad
```

### 添加持续集成文件.gitlab-ci.yml

```
stages:
  - style
  - test

pep8:
  stage: style
  script:
    - pip install tox -i https://pypi.mirrors.ustc.edu.cn/simple/ 
    - tox -e pep8 -i https://pypi.mirrors.ustc.edu.cn/simple/ 
  tags:
    - python2.7

unittest-py27:
  stage: test
  script:
    - pip install tox -i https://pypi.mirrors.ustc.edu.cn/simple/ 
    - tox -e py27 -i https://pypi.mirrors.ustc.edu.cn/simple/ 
  tags: 
    - python2.7

unittest-py34:
  stage: test
  script:
    - pip install tox -i https://pypi.mirrors.ustc.edu.cn/simple/ 
    - tox -e py34 -i https://pypi.mirrors.ustc.edu.cn/simple/ 
  tags: 
    - python3.4
```

### README.md文件pipeline状态

```
pipline状态：

[![pipeline status](http://gitlab.example.com/qkong/docker-cloud-flask-demo/badges/master/pipeline.svg)](http://gitlab.example.com/qkong/docker-cloud-flask-demo/commits/master)

代码覆盖率：

[![coverage report](http://gitlab.example.com/qkong/docker-cloud-flask-demo/badges/master/coverage.svg)](http://gitlab.example.com/qkong/docker-cloud-flask-demo/commits/master)
```

### 修改python代码覆盖率对应的正则表达式

```
Settings>CI/CD>General pipelines settings>Test coverage parsing

TOTAL\s+\d+\s+\d+\s+(\d+)%
```

### 部署项目

1. 添加shell类型的Runner:

```
[root@gitlab-ci vagrant]# gitlab-ci-multi-runner register
Running in system-mode.

Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://gitlab.example.com/
Please enter the gitlab-ci token for this runner:
Zxyg8wLQLCgzup-Sa_Qq
Please enter the gitlab-ci description for this runner:
[gitlab-ci]:
Please enter the gitlab-ci tags for this runner (comma separated):
demo
Whether to run untagged builds [true/false]:
[false]:
Whether to lock Runner to current project [true/false]:
[false]:
Registering runner... succeeded                     runner=Zxyg8wLQ
Please enter the executor: docker, parallels, docker-ssh+machine, docker-ssh, shell, ssh, virtualbox, docker+machine, kubernetes:
shell
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

2. 在.gitlab-ci.yml添加docker构建和部署脚本

```
stages:
  - style
  - test
  - deploy

pep8:
  stage: style
  script:
    - pip install tox -i https://pypi.mirrors.ustc.edu.cn/simple/ 
    - tox -e pep8 -i https://pypi.mirrors.ustc.edu.cn/simple/ 
  tags:
    - python2.7

unittest-py27:
  stage: test
  script:
    - pip install tox -i https://pypi.mirrors.ustc.edu.cn/simple/ 
    - tox -e py27 -i https://pypi.mirrors.ustc.edu.cn/simple/ 
  tags: 
    - python2.7

unittest-py34:
  stage: test
  script:
    - pip install tox -i https://pypi.mirrors.ustc.edu.cn/simple/ 
    - tox -e py34 -i https://pypi.mirrors.ustc.edu.cn/simple/ 
  tags: 
    - python3.4

docker-deploy:
    stage: deploy
    script: 
      - docker build -t flask-demo .
      - if [ $(docker ps -aq --filter name=web) ];then docker rm -f web;fi
      - docker run -d --name web -p 5000:5000 flask-demo
    tags:
      - demo

```


## 设置分支保护

Settings>Repository>Protected Branches>Allowed to push 设置不允许任何人提交到master

Settings>General>Merge request settings>Only allow merge requests to be merged if the pipeline succeeds 只有pipeline成功才能合并代码


修改.gitlab-ci.yml只允许master部署
```
stages:
  - style
  - test
  - deploy

pep8:
  stage: style
  script:
    - pip install tox -i https://pypi.mirrors.ustc.edu.cn/simple/ 
    - tox -e pep8 -i https://pypi.mirrors.ustc.edu.cn/simple/ 
  tags:
    - python2.7

unittest-py27:
  stage: test
  script:
    - pip install tox -i https://pypi.mirrors.ustc.edu.cn/simple/ 
    - tox -e py27 -i https://pypi.mirrors.ustc.edu.cn/simple/ 
  tags: 
    - python2.7

unittest-py34:
  stage: test
  script:
    - pip install tox -i https://pypi.mirrors.ustc.edu.cn/simple/ 
    - tox -e py34 -i https://pypi.mirrors.ustc.edu.cn/simple/ 
  tags: 
    - python3.4

docker-deploy:
    stage: deploy
    script: 
      - docker build -t flask-demo .
      - if [ $(docker ps -aq --filter name=web) ];then docker rm -f web;fi
      - docker run -d --name web -p 5000:5000 flask-demo
    tags:
      - demo
  	only:
  	  - master
```

## git工作流

[https://nvie.com/posts/a-successful-git-branching-model/?](https://nvie.com/posts/a-successful-git-branching-model/?)