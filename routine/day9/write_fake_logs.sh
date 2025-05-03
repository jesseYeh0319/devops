#!/bin/bash
mkdir -p /home/jesse/文件/devops/routine/day9/logs
NOW=$(date '+%Y-%m-%d_%H:%M:%S')
echo "[$NOW] 假的 log 資料 - $(uuidgen)" >>  /home/jesse/文件/devops/routine/day9/logs/app.log






