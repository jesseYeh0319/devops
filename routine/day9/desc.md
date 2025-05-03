# ✅ DevOps120-技術轉職｜Day 9：模擬應用寫入 Log，驗證清理流程自動化

## 🎯 今日目標

- ✅ 建立一個模擬應用程式，自動寫入 log 檔案
- ✅ 搭配 log-cleaner 容器每日清理過期 log
- ✅ 模擬「真實應用產生 log → 清除 → 通知」的自動化流程

---

## 🛠️ 1️⃣ 建立模擬 log 產生腳本

建立檔案 `write_fake_logs.sh`：

```bash
#!/bin/bash
mkdir -p logs
NOW=$(date '+%Y-%m-%d_%H:%M:%S')
echo "[$NOW] 假的 log 資料 - $(uuidgen)" >> logs/app.log
```

加上執行權限：

```bash
chmod +x write_fake_logs.sh
```

---

## ⚙️ 2️⃣ 建立排程（每分鐘產一筆 log）

```bash
crontab -e
```

新增一行（每分鐘執行一次）：

```cron
* * * * * /home/jesse/文件/devops/routine/day9/write_fake_logs.sh
```

> ✅ 請依你實際的絕對路徑修改 `/home/jesse/...`

---

## 📦 3️⃣ 執行 log-cleaner docker 容器（清除過期 log）

模擬清理：

```bash
docker run --rm \
  -v $(pwd)/logs:/opt/java-app/logs \
  log-cleaner
```

此時只會刪掉 `mtime > KEEP_DAYS` 的 `.log` 檔

---

## 🧪 4️⃣ 測試效果

手動產生舊檔案（模擬 10 天前的 log）：

```bash
echo "old" > logs/old1.log
touch -d "10 days ago" logs/old1.log
```

執行 cleaner：

```bash
docker run --rm -v $(pwd)/logs:/opt/java-app/logs log-cleaner
```

✔ 若成功，應會自動刪除舊 log，並觸發 Slack 通知（Day 5 整合的功能）

---

## ✅ 今日學會技能

| 技術                        | 用途                             |
|-----------------------------|----------------------------------|
| Shell 腳本自動寫 log        | 模擬 app log 行為                 |
| crontab                     | 週期性執行腳本                   |
| 日誌清理與實際應用整合     | 驗證 DevOps 自動化監控效益       |

---

## 🧠 面試時怎麼講？

> 我用 shell 模擬應用持續寫入 log，再以 log-cleaner docker 容器每天清除超過 7 天的檔案，並結合 Slack Webhook 自動發送清理結果，落實 log retention policy 的自動化。

---

## 📌 延伸任務（選配）

- 使用 Python 模擬 app，自動每天寫 log
- 將 cleaner 設為 crontab 排程（或 systemd 定時任務）
- 設定 logs 檔名帶上日期（`app-2025-05-03.log`）

