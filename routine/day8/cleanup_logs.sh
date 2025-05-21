#!/bin/bash

# === 設定區 ===

DEFAULT_TARGET_DIR="/opt/java-app/logs"
DEFAULT_KEEP_DAYS=7
CONFIG_FILE=".env"

# === 載入變數 ===

if [ -f "$CONFIG_FILE" ]; then
  export $(grep -v '^#' "$CONFIG_FILE" | xargs)
fi

# === 參數設定 ===

TARGET_DIR="$DEFAULT_TARGET_DIR"
KEEP_DAYS="$DEFAULT_KEEP_DAYS"

if [ -n "$1" ]; then
  TARGET_DIR="$1"
fi

if [ -n "$2" ]; then
  KEEP_DAYS="$2"
fi

# === 顯示資訊 ===

echo "🚮 正在清理目錄：$TARGET_DIR"
echo "📌 將刪除超過 $KEEP_DAYS 天的 .log 檔案"

# === 找出符合條件的檔案 ===

MATCHED_FILES=$(find "$TARGET_DIR" -type f -name "*.log" -mtime +$KEEP_DAYS)

if [ -z "$MATCHED_FILES" ]; then
  echo "✅ 沒有符合條件的檔案可刪除"
  DELETED_COUNT=0
else
  echo "🔍 找到以下檔案準備刪除："
  echo "$MATCHED_FILES"
  echo "$MATCHED_FILES" | xargs -r rm -v
  DELETED_COUNT=$(echo "$MATCHED_FILES" | wc -l)
fi

# === 組合 Slack 訊息 ===

CURRENT_TIME=$(date '+%Y-%m-%d %H:%M')
MESSAGE="✅ Log 清理完成：$CURRENT_TIME\n路徑：$TARGET_DIR\n保留：$KEEP_DAYS 天\n$DELETED_COUNT 個檔案已刪除"

# === 發送通知 ===

if [ -n "$SLACK_WEBHOOK" ]; then
  curl -X POST -H 'Content-type: application/json' \
       --data "{\"text\":\"$MESSAGE\"}" "$SLACK_WEBHOOK"
else
  echo "⚠️ 未設定 SLACK_WEBHOOK，略過通知發送"
fi

