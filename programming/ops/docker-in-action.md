# Run

```shell
# 名称为web，守护进程（--detach or -d）
docker run --detach --name web nginx:latest

# 交互式进程
docker run --interactive --tty --link web:web --name web_test busybox:latest /bin/sh

# readonly
docker run -d --name wp --read-only wordpress:4

# remove after exiting
docker run -it --rm dockerinaction/ch3_ex2_hunt
```

# Inspect & Logs

```shell
docker inspect --format "{{.State.Running}}" wp

# logs
docker logs wp
```

# Ps

```shell
# running ps
docker ps

# all ps
docker ps -a

# 最新创建的容器id
CID=$(docker ps --latest --quiet)

# stop all
docker stop $(docker ps -aq)

# remove all
docker rm $(docker ps -aq)
```

# Exec

```shell
# Run a cmd in a running container
docker exec bb7c9821c6d6 echo hello

```

# 综合应用示例

```shell
MAILER_CID=$(docker run -d dockerinaction/ch2_mailer)

WEB_CID=$(docker run -d nginx)

AGENT_CID=$(docker run -d --link $WEB_CID:insideweb --link $MAILER_CID:insidemailer dockerinaction/ch2_agent)
```

# Docker Hub

## Search

`docker search julia`

检查输出的的Official和Automated列。

