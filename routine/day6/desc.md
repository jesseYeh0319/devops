# ✅ DevOps120-技術轉職｜Day 6：將 log 清理腳本 Docker 化（支援 .env）

---

## 🎯 今日目標

- ✅ 將 `cleanup_logs.sh` 包裝進 Docker Image，變成可攜、可重用的容器  
- ✅ 使用 `.env` 管理 Slack Webhook，避免硬編碼  
- ✅ 建立 `build.sh` 一鍵打包腳本  
- ✅ 完成 `docker run` 測試：能清理 log 並推送 Slack 通知  

---

## 🗂 專案結構

```
devops-cleaner/
├── Dockerfile              ← 容器建構說明
├── cleanup_logs.sh         ← log 清理腳本
├── .env                    ← 環境變數（Slack Webhook）
├── build.sh                ← 一鍵建構腳本
```

---

## 🧾 .env 內容（不要加進 Git）

```env
SLACK_WEBHOOK=https://hooks.slack.com/services/你的真實webhook
```

> 加入 `.gitignore` 避免洩漏敏感資訊：

```
.env
```

---

## 📝 cleanup_logs.sh（已支援載入 .env）

```bash
#!/bin/bash

# 預設參數
TARGET_DIR="/opt/java-app/logs"
KEEP_DAYS=7

# 載入 .env 變數
if [ -f ".env" ]; then
  export $(grep -v '^#' .env | xargs)
fi

# 覆寫參數
if [ -n "$1" ]; then
  TARGET_DIR="$1"
fi
if [ -n "$2" ]; then
  KEEP_DAYS="$2"
fi

echo "🚮 正在清理 $TARGET_DIR 中超過 $KEEP_DAYS 天的 log 檔案..."

# 找出要刪除的清單
TO_DELETE=$(find "$TARGET_DIR" -type f -name "*.log" -mtime +$KEEP_DAYS)

# 刪除並統計數量
echo "$TO_DELETE" | xargs -r rm -v
COUNT=$(echo "$TO_DELETE" | grep -c '^')

# 組合 Slack 訊息
MESSAGE="✅ Log 清理完成：$(date '+%Y-%m-%d %H:%M')\n路徑：$TARGET_DIR\n保留：$KEEP_DAYS 天\n$COUNT 個檔案已刪除"

# 發送 Slack 通知
curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"$MESSAGE\"}" "$SLACK_WEBHOOK"
```

---

## 🧱 Dockerfile

```dockerfile
FROM alpine:3.18

RUN apk add --no-cache bash curl grep coreutils

WORKDIR /app
COPY cleanup_logs.sh /app/cleanup_logs.sh
COPY .env /app/.env

ENTRYPOINT ["./cleanup_logs.sh"]
```

---

## 🛠️ build.sh

```bash
#!/bin/bash
docker build -t log-cleaner .
```

```bash
chmod +x build.sh
./build.sh
```

---

## 🚀 執行 Docker 清理 + 通知測試

```bash
docker run --rm \
  -v /opt/java-app/logs:/opt/java-app/logs \
  log-cleaner
```

---

## ✅ 成功標準

- [ ] 可以用 `docker run` 成功執行清理  
- [ ] Slack 頻道有正確接收到通知  
- [ ] `.env` 可以快速更新 webhook 而不修改程式  
- [ ] build 過程不出錯，容器打包成功  

