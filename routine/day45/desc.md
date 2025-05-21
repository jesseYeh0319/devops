# 🧩 DevOps140 技術轉職計畫

## 📅 Day 45：設計 dev / staging / prod 多組 `.env` 結構

### 🎯 今日目標

建立一套乾淨可維護的多環境 `.env` 管理架構，讓你能快速在開發（dev）、測試（staging）、正式（prod）之間切換，搭配 Docker Compose 統一控制容器部署行為。

---

## 📁 建立環境變數檔案

在專案根目錄建立以下三個 `.env` 檔：

```
.env.dev
.env.staging
.env.prod
```

---

## 📝 `.env` 內容範例

### `.env.dev`

```dotenv
APP_PORT=8082
DB_PORT=5432
SPRING_PROFILES_ACTIVE=dev
POSTGRES_DB=mydb
POSTGRES_USER=devuser
POSTGRES_PASSWORD=devpass
DB_VOLUME_NAME=pg_data_dev
```

### `.env.staging`

```dotenv
APP_PORT=8082
DB_PORT=5432
SPRING_PROFILES_ACTIVE=staging
POSTGRES_DB=mydb_stage
POSTGRES_USER=stageuser
POSTGRES_PASSWORD=stagepass
DB_VOLUME_NAME=pg_data_staging
```

### `.env.prod`

```dotenv
APP_PORT=80
DB_PORT=5432
SPRING_PROFILES_ACTIVE=prod
POSTGRES_DB=mydb_prod
POSTGRES_USER=produser
POSTGRES_PASSWORD=prodpass
DB_VOLUME_NAME=pg_data_prod
```

---

## 📦 docker-compose.yml 範例結構（可共用）

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "${APP_PORT}:8082"
    environment:
      - SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}
    depends_on:
      - db
    networks:
      - backend

  db:
    image: postgres:14
    ports:
      - "${DB_PORT}:5432"
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - ${DB_VOLUME_NAME}:/var/lib/postgresql/data
    networks:
      - backend

volumes:
  pg_data_dev:
  pg_data_staging:
  pg_data_prod:

networks:
  backend:
```

---

## 🚀 啟動對應環境指令

```bash
# 啟動開發環境
docker compose --env-file .env.dev up --build -d

# 啟動測試環境
docker compose --env-file .env.staging up --build -d

# 啟動正式環境
docker compose --env-file .env.prod up --build -d
```

---

## 🛑 停止與清除 Volume

```bash
# 停止並刪除開發環境容器與資料
docker compose --env-file .env.dev down -v

# 停止並刪除正式環境
docker compose --env-file .env.prod down -v
```

---

## 🧠 小提醒

- `.env` 裡的變數若沒有帶 `--env-file`，預設只讀 `.env`
- Volume 名請區分不同環境，避免資料覆蓋
- `.env.*` 建議加入 `.gitignore`，避免密碼洩漏
- 執行前記得 `.env.xxx` 中的 key 都要能對應 `docker-compose.yml` 裡的 `${}` 變數

---

## 🗣️ 面試口語建議

> 我使用多組 `.env` 搭配 Docker Compose 部署不同環境，並透過明確命名與 volume 分隔，確保開發、測試與正式環境能安全隔離，部署時只需切換 `.env` 即可快速上線。

