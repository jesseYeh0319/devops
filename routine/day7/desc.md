# ✅ DevOps120-技術轉職｜Day 7：排程執行 Docker 任務（log-cleaner）

---

## 🎯 今日目標

- ✅ 使用 Linux `crontab` 設定排程任務  
- ✅ 每天定時執行 `docker run log-cleaner` 清理 log  
- ✅ 測試自動化是否能正常發送 Slack 通知  
- ✅ 可選：將每次執行結果記錄至 log 檔中

---

## 📌 前情提要：本任務延續 Day 6 成果

> 在 Day 6，你已：
>
> - 撰寫 `cleanup_logs.sh` 腳本並支援 `.env`
> - 使用 `Dockerfile` 建立 `log-cleaner` 映像
> - 加入 `ENTRYPOINT ["./cleanup_logs.sh"]` → 容器啟動即自動執行該腳本
>
> ✅ 所以 **Day 7 的目標不是寫新程式，而是讓這顆容器每天自動執行一次。**

---

## 🧰 1️⃣ 建立執行指令包裝腳本：`run_cleaner.sh`

```bash
#!/bin/bash

docker run --rm \
  -v /opt/java-app/logs:/opt/java-app/logs \
  log-cleaner
```

設為可執行：

```bash
chmod +x run_cleaner.sh
```

你可以放在 `~/devops-cleaner/` 專案資料夾中。

---

## 🧭 2️⃣ 使用 `crontab` 設定定時排程

打開排程編輯器：

```bash
crontab -e
```

新增以下排程內容：

```cron
0 3 * * * /home/jesse/devops-cleaner/run_cleaner.sh >> /var/log/log-cleaner.log 2>&1
```

📌 說明：

- `0 3 * * *`：每天凌晨 3 點執行一次
- `>> ... 2>&1`：將標準輸出與錯誤輸出都記錄到 `/var/log/log-cleaner.log`
- 請將路徑 `/home/jesse/...` 改為你實際的腳本路徑

---

## 🧪 3️⃣ 測試腳本功能

先手動執行一次腳本確認是否正常：

```bash
./run_cleaner.sh
```

檢查以下項目：

- [ ] 有正確刪除超過天數的 log 檔案
- [ ] Slack 有接收到通知訊息
- [ ] `.env` 有正確載入 Slack Webhook
- [ ] 容器是否執行成功並自動退出

---

## ✅ 成功標準

- [ ] crontab 可定期執行 Docker 容器任務
- [ ] 不需手動干預即可每日自動清理
- [ ] Slack 通知可作為排程成功與否的回報依據
- [ ] `.env` 隔離敏感資訊，維護便利

---

## 📌 延伸任務（選配）

- 實作多組目錄排程（多個容器任務）
- 整合 Jenkins 定期觸發清理任務
- 建立 `crontab` 管理模板，自動安裝時套用


