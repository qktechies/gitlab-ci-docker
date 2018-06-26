
# 登录dnsserver

```
vagrant ssh dnsserver
```

# 安装dnsmasq

```
sudo yum -y install dnsmasq
```

# 配置DNS服务

```
sudo vi /etc/resolv.dnsmasq

nameserver 114.114.114.114
nameserver 8.8.8.8
```

# 配置本地解析规则

```
sudo vi /etc/dnsmasqhosts

192.168.211.10 gitlab.example.com
```

# 修改配置文件

```
sudo vi /etc/dnsmasq.conf

resolv-file=/etc/resolv.dnsmasq
addn-hosts=/etc/dnsmasqhosts
```

# 启动dnsmasq服务

```
sudo systemctl start dnsmasq
sudo systemctl enable dnsmasq 
```

最后设置本机的dns服务器为192.168.211.12