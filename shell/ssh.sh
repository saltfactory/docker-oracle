#!/bin/bash

ORACLE_HOST=$(echo "$DOCKER_HOST" | sed -E 's/(tcp:\/\/)(([0-9]+\.){3}[0-9]+)[^ ]+/\2/g')
ssh -oPort=9001 oracle@$ORACLE_HOST
