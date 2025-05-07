# 🚀 DevOps120 - 技術轉職計畫：Day 23

## 🎯 主題：撰寫 `.env` 並整合 Docker Compose 管理參數

---

## 📌 今日目標

- 使用 `.env` 檔案集中管理環境變數（port、DB 帳密等）
- 在 `docker-compose.yml` 中引用 `.env` 參數，減少硬編碼
- 實作一份跨環境共用的設定模板
- 確保可由 Jenkins 或開發人員快速切換環境

---

## 🛠️ 步驟一：建立 `.env` 檔案

與 `docker-compose.yml` 同層，範例如下：

```env
APP_PORT=8080
DB_PORT=5432
SPRING_PROFILES_ACTIVE=dev
POSTGRES_DB=mydb
POSTGRES_USER=user
POSTGRES_PASSWORD=password
```

---

## 🛠️ 步驟二：修改 `docker-compose.yml` 讀取 `.env`

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "${APP_PORT}:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}

  db:
    image: postgres:14
    restart: always
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "${DB_PORT}:5432"
    volumes:
      - pg_data:/var/lib/postgresql/data

volumes:
  pg_data:
```

---

## 🧪 驗證方式

```bash
# 檢查 .env 是否正確套用
docker-compose config

# 啟動容器
docker-compose up -d

# 查看 app 環境變數是否正確注入
docker exec -it <app-container> printenv | grep SPRING_PROFILES_ACTIVE
```

---

## 🎯 延伸挑戰（選做）

- 將 `.env.dev`、`.env.prod` 分環境拆分，搭配 `--env-file` 切換
- 用 `.env` 管理 Jenkins webhook secret、Slack URL 等敏感資料
- 撰寫 `.env.example` 作為團隊協作模板

---

## 📚 小結

- `.env` 是 DevOps 中常用的配置管理方式
- 配合 `docker-compose` 可實現零改動快速切環境
- 建議搭配 `.env.example` 與 `.gitignore`，避免敏感資訊入庫

