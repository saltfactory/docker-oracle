#!/bin/bash

docker run --name oracle \
-d -p 9001:22 -p 9002:1521 -p 9003:8080 \
saltfactory/oracle
