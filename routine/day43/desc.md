# 🐳 DevOps140 技術轉職計畫

## 📅 Day 43：使用 Docker Compose 啟動多容器應用

### 🎯 今日目標

學會使用 `docker compose` 建立多容器服務，並透過 `depends_on`、`environment` 等設定完成基本後端 + 資料庫的容器協作。

---

### 🧱 基本 docker-compose.yml 範例

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "${APP_PORT}:8082"
    depends_on:
      - db
    environment:
      - SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}
    networks:
      - backend

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
      - ${DB_VOLUME_NAME}:/var/lib/postgresql/data
    networks:
      - backend

networks:
  backend:

volumes:
  pg_data_dev:
  pg_data_prod:
```

---

### 💡 常見提問統整（Day 43）

#### ❓ `depends_on` 是什麼？

讓 app 容器啟動時「等 db 先啟動完再開始」，但這並不保證資料庫初始化完成，僅做「啟動順序控制」。

#### ❓ `environment` 可以怎麼寫？

```yaml
# 這兩種寫法等價
environment:
  - SPRING_PROFILES_ACTIVE=dev

# 或寫成 map 形式
environment:
  SPRING_PROFILES_ACTIVE: dev
```

#### ❓ services 沒寫 networks 會怎樣？

`docker compose` 預設會建立一張 `專案名_default` 的 network，所有服務自動加入。  
你可以不寫 `networks:`，但若你要控管誰能互通、誰不能，就要自己分組定義。

---
