# ✅ [DevOps120-技術轉職] Day 10：用 `log-cleaner` 容器清理外部資料夾 log

## 🎯 今日目標

- 學會如何讓容器清理「外部資料夾」
- 熟悉 Docker Volume 掛載（Volume Mount）
- 實作「本機模擬專案 log → 容器清理 → Slack 通知」完整流程

---

## 🔧 實作任務

### 1️⃣ 確保 logs 資料夾存在並有假資料

```bash
mkdir -p logs
touch -d "8 days ago" logs/old.log
touch logs/today.log
```

---

### 2️⃣ 使用 log-cleaner 清理外部 logs 資料夾

```bash
docker run --rm \
  -v $(pwd)/logs:/opt/java-app/logs \
  log-cleaner
```

> ✅ `/opt/java-app/logs` 是容器內部使用的清理路徑，實際會映射到主機的 `logs` 資料夾

---

### 3️⃣ Slack Webhook 是否有發送訊息？

如果你已整合 `.env` 並正確讀取，Slack 頻道應收到通知，例如：

```
✅ Log 清理完成：2025-05-03 12:00
路徑：/opt/java-app/logs
保留：7 天
1 個檔案已刪除
```

---

## 🧪 驗證結果

```bash
ls logs
```

你應該只會看到 `today.log`，表示 7 天以上的 `old.log` 已被成功刪除。

---

## 📌 補充說明

- 此為 Docker 清理外部 Volume 的實戰入門
- 掛載目錄路徑 `-v /主機路徑:/容器路徑` 是雙向同步
- 容器內刪除實際會改變主機的資料夾內容

---

## 🧠 面試時怎麼講？

> 我曾使用 Docker 封裝 log 清理器，透過 Volume 掛載讓容器直接操作主機目錄，搭配 Slack Webhook 回報清理結果，實作出完整的 DevOps log retention 自動化解決方案。

