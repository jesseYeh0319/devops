## 📅 Day 44：設定 Volume、Network 與環境切換

### 🎯 今日目標

理解 volume 的綁定差異、network 的通訊邏輯，以及 `.env` 檔切換 dev / prod 環境。

---

### 🗃️ Volume 差異說明

```yaml
# Docker volume（Docker 自動管理）
volumes:
  - pg_data:/var/lib/postgresql/data

# Bind mount（你主機指定路徑）
volumes:
  - /home/jesse/mydb:/var/lib/postgresql/data
```

✅ 有 `/` 的是主機路徑，要自己先建資料夾  
✅ 沒 `/` 是 docker volume，Docker 自動建立、管理

---

### 🌐 Network 設計說明

```yaml
networks:
  backend:
  frontend:
```

- app 跟 db 同在 `backend`，可以互 ping、互連資料庫
- frontend 可以給 NGINX 或前端服務分開部署
- 用 network 分組可以有效隔離不同系統，避免資料誤連

---

### 🧪 使用 .env 切換 dev / prod 設定

`.env.dev`：
```
APP_PORT=8082
DB_PORT=5432
SPRING_PROFILES_ACTIVE=dev
POSTGRES_DB=mydb
POSTGRES_USER=user
POSTGRES_PASSWORD=password
DB_VOLUME_NAME=pg_data_dev
```

啟動指令：

```bash
docker compose --env-file .env.dev up --build -d
```

停止與刪除 Volume：

```bash
docker compose --env-file .env.dev down -v
```

---

### ⚠️ 問題與錯誤處理整理

#### ❌ 沒有定義 volume：

```
service "db" refers to undefined volume default
```

🔍 這是因為你使用了：

```yaml
volumes:
  - ${DB_VOLUME_NAME}:/var/lib/postgresql/data
```

但 `.env` 沒設或沒有帶 `--env-file`，導致變數變空值 → Docker 會誤判為 `default`，然後找不到 volume。

✅ 解法：

1. `.env.dev` 要有 `DB_VOLUME_NAME=pg_data_dev`
2. `volumes:` 區塊要有 `pg_data_dev:` 定義
3. 使用 `--env-file` 明確指定

---

#### ❓ 為什麼要加 `--env-file`？

因為 `docker compose` 不會自動讀取 `.env.dev`，只會自動讀取 `.env`（預設檔案）

你沒加 `--env-file` 就會導致環境變數為空，volume name 變成空字串或 default！

---

#### ❓ 為什麼 `version: '3.8'` 會出現警告？

```
WARN: the attribute `version` is obsolete
```

這是因為新版 `docker compose` CLI plugin 已經採用新版 Compose Specification，不再需要 version。

✅ 解法：把 `version: '3.8'` 那行刪掉即可，完全不影響功能。

---

### 🗣️ 面試口語說法範例

> 我在專案中用 docker compose 定義多個服務，並透過 `.env` 做 dev 與 prod 切換，volume 與 network 也會明確定義，以確保資料安全與服務隔離。我也熟悉 `--env-file` 與預設 `.env` 的差異，能處理 compose volume 沒定義或參數遺漏導致的錯誤。

```bash
docker compose --env-file .env.dev up --build -d
docker compose --env-file .env.dev down -v
```

---
