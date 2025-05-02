#!/bin/bash

# 預設值
TARGET_DIR="/opt/java-app/logs"
KEEP_DAYS=7

# 載入 .env 裡的變數
if [ -f ".env" ]; then
  export $(grep -v '^#' .env | xargs)
fi

# 如果有輸入參數就覆蓋
if [ $# -ge 1 ]; then
  TARGET_DIR="$1"
fi
if [ $# -ge 2 ]; then
  KEEP_DAYS="$2"
fi

echo "🚮 正在清理 $TARGET_DIR 中超過 $KEEP_DAYS 天的 log 檔案..."

# 找出要刪除的檔案清單
TO_DELETE=$(find "$TARGET_DIR" -type f -name "*.log" -mtime +$KEEP_DAYS)

# 實際刪除
echo "$TO_DELETE" | xargs -r rm -v

# 計算刪除數量
COUNT=$(echo "$TO_DELETE" | grep -c '^')

# 組裝訊息內容
MESSAGE="✅ Log 清理完成：$(date '+%Y-%m-%d %H:%M')\n路徑：$TARGET_DIR\n保留：$KEEP_DAYS 天\n$COUNT 個檔案已刪除"

# 傳送通知
curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"$MESSAGE\"}" "$SLACK_WEBHOOK"

