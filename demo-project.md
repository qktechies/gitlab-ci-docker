

## 创建一个demo工程

## 添加README.md文件

```
demo project README
```

## 注册一个对应工程的Runner

```
[vagrant@gitlab-ci scripts]$ sudo gitlab-ci-multi-runner register
Running in system-mode.

Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://gitlab.example.com
Please enter the gitlab-ci token for this runner:
KVqgHUD_smkoCM3A7G3V
Please enter the gitlab-ci description for this runner:
[gitlab-ci]:

▽
Please enter the gitlab-ci tags for this runner (comma separated):
demo,test
Whether to run untagged builds [true/false]:
[false]:
Whether to lock Runner to current project [true/false]:
[false]:
Registering runner... succeeded                     runner=KVqgHUD_
Please enter the executor: parallels, shell, ssh, virtualbox, docker+machine, docker-ssh+machine, docker, docker-ssh, kubernetes:
shell
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

### 添加持续集成文件.gitlab-ci.yml

```
stages:
    - build
    - test
    - deploy

job1:
  stage: build
  tags: 
    - demo
  script: 
    - echo "build start...."
    - echo "I am in build stage"
    - echo "build end..."

job2:
  stage: test
  tags: 
    - demo
  script: 
    - echo "test start...."
    - echo "I am in test stage"
    - echo "test end..."

job3:
  stage: deploy
  tags: 
    - demo
  script: 
    - echo "deploy start...."
    - echo "I am in deploy stage"
    - echo "deploy end..."
```

### 推送代码

```
git add .
git commit -m 'first commmit'
```

### 修改.gitlab-ci.yml故意造成错误的测试

```
job3:
  stage: deploy
  tags: 
    - demo
  script: 
    - echoh "deploy start...."
    - echo "I am in deploy stage"
    - echo "deploy end..."
```

```
git add .
git commit -m 'test deploy error'
git push
```