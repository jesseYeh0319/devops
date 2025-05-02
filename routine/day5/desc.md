# ✅ DevOps120-技術轉職｜Day 5：實作 Log 清理結果通知（Slack Webhook）

## 🎯 今日目標

- ✅ 將 `cleanup_logs.sh` 執行結果整合成訊息  
- ✅ 使用 Slack Webhook 傳送通知到頻道  
- ✅ 為腳本加上「可見反饋」，提升信任與可追蹤性  
- ✅ 修正 log 已刪但顯示為 0 的問題（同步刪除與統計）

---

## 🔧 1️⃣ 建立 Slack Webhook

1. 前往：https://api.slack.com/apps  
2. 點選「Create New App」→ 選 From scratch  
3. 填入 App 名稱（例如：`DevOps Logger`），選擇你的 workspace  
4. 左側點選「Incoming Webhooks」→ 開啟開關  
5. 點「Add New Webhook to Workspace」  
6. 選擇一個頻道（例如：`#devops-log`）  
7. 建立後，會拿到一組 Webhook URL，例如：  
   `https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX`

---

## 🛠️ 2️⃣ 修改 `cleanup_logs.sh`，加入 Slack 通知（同步統計）

在腳本最後加上這段：

```bash
# --- Slack Webhook 通知設定 ---
SLACK_WEBHOOK="https://hooks.slack.com/services/你的路徑請貼這裡"

# 找出要刪除的檔案清單
TO_DELETE=$(find "$TARGET_DIR" -type f -name "*.log" -mtime +$KEEP_DAYS)

# 執行刪除
echo "$TO_DELETE" | xargs -r rm -v

# 統計實際刪除的檔案數量
COUNT=$(echo "$TO_DELETE" | grep -c '^')

# 組裝訊息
MESSAGE="✅ Log 清理完成：$(date '+%Y-%m-%d %H:%M')\n路徑：$TARGET_DIR\n保留：$KEEP_DAYS 天\n$COUNT 個檔案已刪除"

# 發送 Slack 通知
curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"$MESSAGE\"}" "$SLACK_WEBHOOK"
```

---

## 🧪 3️⃣ 測試效果

執行腳本：

```bash
./cleanup_logs.sh
```

如果成功，你的 Slack 頻道應該會出現訊息，例如：

```bash
✅ Log 清理完成：2024-05-02 03:20
路徑：/opt/java-app/logs
保留：7 天
2 個檔案已刪除
```

---

## ✅ 今日學會技能

| 技術               | 用途                                 |
|--------------------|--------------------------------------|
| Slack Webhook       | 免費穩定的企業級訊息推播服務         |
| `curl -X POST`     | 向 API 發送 JSON 資料               |
| `--data "{...}"`   | 組成符合 Slack 格式的 JSON 結構      |
| `$(...)`           | Shell 中執行指令並插入輸出結果      |
| `xargs -r rm`      | 批次刪除多個檔案，空值不報錯        |
| `grep -c '^'`      | 統計行數，確保與實際清單同步        |

---

## 🧠 面試時怎麼講？

> 我將 log 清理器整合 Slack Webhook，每次排程執行後會自動發送訊息到頻道，包含執行時間、刪除檔案數量與路徑。  
> 為了避免統計誤差，我先記錄待刪檔案清單，再執行刪除與通知，這樣能確保訊息真實可靠。

---

## 📌 延伸任務（選配）

- 加入環境變數 `.env` 管理 webhook（避免硬編碼）  
- 根據刪除數量不同發送不同 emoji / 等級通知  
- 整合 Jenkins、Docker 清理、備份通知也發到 Slack
