# ✅ DevOps120-技術轉職｜Day 8：使用 docker-compose 管理多容器

---

## 🎯 今日目標

- ✅ 理解 `docker-compose.yml` 的語法與用途  
- ✅ 使用 `docker-compose` 同時啟動 log-cleaner 與模擬應用容器  
- ✅ 實作 `.env` 與 `volumes` 的多容器整合方式  
- ✅ 學會用 `docker-compose up/down` 管理整體服務組合  

---

## 📘 為什麼要學 `docker-compose`？

- 實務中，一個服務通常包含多個容器（Web + DB + 清理工具 + Nginx）
- 用 `docker run ...` 控一個一個很麻煩
- `docker-compose` 可以一次啟動／停止多個容器，並設定彼此關係
- 是 DevOps 的最小編排實戰工具

---

## 🗂️ 1️⃣ 專案結構（Day 8）

```
devops-cleaner/
├── docker-compose.yml         ← 新增的重點檔案
├── cleanup_logs.sh
├── Dockerfile
├── .env
├── build.sh
```

---

## 📝 2️⃣ 建立 `docker-compose.yml`

```yaml
version: "3.9"
services:
  log-cleaner:
    build: .
    container_name: log-cleaner
    volumes:
      - /opt/java-app/logs:/opt/java-app/logs
    env_file:
      - .env
    restart: "no"
```

說明：

- `build: .` → 使用當前目錄的 Dockerfile 建 image  
- `volumes` → 掛載主機 log 資料夾  
- `env_file` → 讀取 `.env` 變數給容器使用  
- `restart: "no"` → 清理腳本通常跑完就退出，不需自動重啟  

---

## 🛠️ 3️⃣ 執行 docker-compose

### 第一次建構與啟動

```bash
docker-compose up --build
```

### 停止與移除容器

```bash
docker-compose down
```

### 單獨重啟某個容器

```bash
docker-compose up log-cleaner
```

---

## 🧪 4️⃣ 驗證成功標準

- [ ] `docker-compose up` 能執行清理流程並印出輸出  
- [ ] `.env` 能正確被使用  
- [ ] Slack 收到通知  
- [ ] 不會留下多餘容器（用 `docker ps` 查看）  

---

## 📌 延伸應用（選配）

- 加入 `app` 容器模擬應用服務，再掛共用 log volume  
- 使用 `depends_on: app` 控制清理順序  
- 建立 `.env.production`、`.env.test` 實作環境切換  

```bash
docker-compose --env-file .env.production up
```

---

