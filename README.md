docker-oracle
=============

This image installed **Oracle XE(11.2.0)** on **Oracle Linux 7**.

included **Oracle Linux 7** image is https://registry.hub.docker.com/u/saltfactory/oraclelinux/

Usage
===========

## Create Docker Image
If you want to pull docker image from docker hub

```
docker pull saltfactory/oracle-xe
```

If you want to build via Dockerfile fron github

```
git clone https://github.com/saltfactory/docker-oracle.git
```

and download [Oracle Database Express Edition 11g Release 2 for Linux](http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip) and unzip it in `docker-oracle` directory.

```
unzip oracle-xe-11.2.0-1.0.x86_64.rpm.zip
```

and build

```
docer build -t saltfactory/oracle .
```

## Run Container

```
docker run --name oracle -d -p 9001:22 -p 9002:1521 -p 9003:8080 saltfactory/oracle

```

## Connection

If you want to connect via **ssh**, password is ~~oracle~~

```
ssh -oPort=9001 oracle@localhost
```

If you want to connect via **sqlplus**, password is ~~oracle~~~

```
sqlplus system/oracle@'(description=(address_list=(address=(protocol=TCP)(host=localhost)(port=9002)))(connect_data=(service_name=XE)))'
```

boot2docker usage
=================

If you install **Oracle** on boot2docker. You must have 2G over swap memory. Unfortunately, boot2docker run docker on VirtualBox that has variable swap memory size. So When you init boot2docker, you setting enough memory size.

```
boot2docker init --memory=5120
```

Next, pull saltfactory/oracke docker image

## Create Docker Image
If you want to pull docker image from docker hub

```
docker pull saltfactory/oracle-xe
```

If you want to build via Dockerfile fron github

```
git clone https://github.com/saltfactory/docker-oracle.git
```

and build

```
docer build -t saltfactory/oracle .
```

## Run Container

```
docker run --name oracle -d -p 9001:22 -p 9002:1521 -p 9003:8080 saltfactory/oracle

```

## Connection

When you use boot2docker, you can not use localhost. boot2docker have internal ip address. you can use it. You can find boot2docker ip address next command

```
boot2docker ip
```

so you can see result.

```
The VM's Host only interface IP address is: 192.168.59.103
```

If you want to connect via **ssh**, password is ~~oracle~~

```
ssh -oPort=9001 oracle@{boot2docker ip}
```

I created shell file that name is `ssh.sh` in `shell` directory.

```sh
#!/bin/bash

ORACLE_HOST=$(echo "$DOCKER_HOST" | sed -E 's/(tcp:\/\/)(([0-9]+\.){3}[0-9]+)[^ ]+/\2/g')
ssh -oPort=9001 oracle@$ORACLE_HOST
```

If you want to connect via **sqlplus**, password is ~~oracle~~~

```
sqlplus system/oracle@'(description=(address_list=(address=(protocol=TCP)(host={boot2docker ip})(port=9002)))(connect_data=(service_name=XE)))'
```

I create shell file that name is `sqlplus.sh` in `shell` directory.

Open browser and you insert http://{boot2docker ip}:9003/apxe

```sh
#!/bin/bash

ORACLE_HOST=$(echo "$DOCKER_HOST" | sed -E 's/(tcp:\/\/)(([0-9]+\.){3}[0-9]+)[^ ]+/\2/g')
sqlplus system/oracle@'(description=(address_list=(address=(protocol=TCP)(host='$ORACLE_HOST')(port=9002)))(connect_data=(service_name=XE)))'
```

Reference
==========

docker-oracle docker file created that based http://blog.grid-it.nl/index.php/2014/05/16/installing-oracle-xe-in-a-docker-image/

and [alexeiled/docker-oracle-xe-11g](https://registry.hub.docker.com/u/alexeiled/docker-oracle-xe-11g/)


LICENSE
========

The MIT License (MIT)

Copyright (c) 2014 SungKwang Song

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
