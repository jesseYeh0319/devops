#!/bin/bash

# 預設值
TARGET_DIR="/opt/java-app/logs"
KEEP_DAYS=7

# 如果有輸入參數就覆蓋
if [ -n "$1" ]; then
  TARGET_DIR="$1"
fi
if [ -n "$2" ]; then
  KEEP_DAYS="$2"
fi

echo "🚮 正在清理 $TARGET_DIR 中超過 $KEEP_DAYS 天的 log 檔案..."

find "$TARGET_DIR" -type f -name "*.log" -mtime +$KEEP_DAYS -exec rm -v {} \;

