#!/bin/bash

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 執行 log-cleaner 容器"

docker run --rm \
  -v /opt/java-app/logs:/opt/java-app/logs \
  log-cleaner

