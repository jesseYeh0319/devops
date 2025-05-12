# 🌐 [DevOps140] Day 48：整合 NGINX / Traefik 實作反向代理

## ✅ 今日目標

- 了解反向代理的角色與位置
- 實作 NGINX 將流量轉發給 app 容器
- 實作 Traefik 自動註冊容器路由（Docker labels）
- 理解反向代理卡死的根本原因（Zombie container）
- 成功清除卡住的 NGINX 容器（AppArmor 原因）

---

## 🔁 什麼是反向代理（Reverse Proxy）？

反向代理會：
- 位在用戶端與後端伺服器之間
- 使用者只看到 proxy 的 IP，不會直接接觸真實伺服器
- 代理伺服器會轉發請求，並將回應回傳給使用者

常見功能：
- 統一入口點
- 隱藏內部結構
- 路由分流（/api、/img）
- SSL 終止（HTTPS）
- 負載平衡

---

## 🧪 NGINX 範例實作：反向代理 Spring Boot App

### 📁 專案結構

```
demo/
├── docker-compose.yml
├── .env.dev
├── app/（Spring Boot）
└── nginx/
    ├── default.conf
    └── Dockerfile
```

### 🔧 nginx/default.conf

```nginx
server {
    listen 80;

    location / {
        proxy_pass http://app:8082;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 🛠 nginx/Dockerfile

```Dockerfile
FROM nginx:latest
COPY default.conf /etc/nginx/conf.d/default.conf
```

### 🧰 docker-compose.yml（精簡版）

```yaml
services:
  nginx:
    build:
      context: ./nginx
    ports:
      - "80:80"
    depends_on:
      - app
    networks:
      - backend
    restart: "no"

  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "${APP_PORT}:8082"
    expose:
      - "8082"
    depends_on:
      - db
    restart: "no"
    environment:
      - SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}
    healthcheck:
      test: ["CMD", "curl", "--fail", "http://localhost:8082/actuator/health"]
      interval: 10s
      timeout: 3s
      retries: 3
      start_period: 20s
    networks:
      - backend

  db:
    image: postgres:14
    restart: "no"
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "5432:5432"
    volumes:
      - ${DB_VOLUME_NAME}:/var/lib/postgresql/data
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $${POSTGRES_USER}"]
      interval: 10s
      timeout: 3s
      retries: 3

networks:
  backend:

volumes:
  pg_data_dev:
  pg_data_prod:
```

---

## ❗ Day48 問題與陷阱紀錄（你問過的精華都在這）

### ✅ 為什麼容器無法刪除？

- 一開始使用了 bind mount：
  ```yaml
  volumes:
    - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
  ```
- 但 VirtualBox 的共享目錄造成鎖死
- 解法是改用 `COPY` → 把設定檔打包進 image
- 並移除 `volumes:` → 就不會有 I/O 鎖定問題

---

### ✅ `COPY` 是什麼意思？

```Dockerfile
COPY default.conf /etc/nginx/conf.d/default.conf
```

- 表示將建置階段的檔案複製進去 image 內部
- 容器啟動時會使用這個內建檔案，不再依賴本機目錄

---

### ✅ 如果我同時用 build 又用 volumes 會怎樣？

```yaml
build:
  context: ./nginx
volumes:
  - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
```

⛔ **這樣會導致 COPY 的檔案馬上被本機的 bind mount 蓋掉**，反而又踩回鎖死地雷。

---

### ✅ 如果我用 `docker stop` 還是無法關閉容器怎麼辦？

- 一開始會以為是 Docker 的 zombie container
- 結果是 **AppArmor profile 殘留**
- 你執行了這個神操作：

```bash
sudo aa-remove-unknown
```

✅ 解鎖所有卡住資源，容器馬上可以正常刪除

---

### ✅ 為什麼我沒用 volume 還會卡住？

因為 zombie container 會「殘留 AppArmor 或 Docker namespace」，即使你重建也會：
- 被 Docker Compose 沿用容器名稱
- 被 AppArmor 拒絕釋放資源

---

### ✅ 如何判斷是 AppArmor 卡住？

```bash
sudo aa-status
```

看到大量 `/usr/bin/docker-default` 或 container 對應不到的 profile → 就是

---

### ✅ 如何永遠避免這種問題再發生？

- 所有容器設定 `restart: "no"`
- nginx 改用 build + COPY，不再用 volumes
- 清場用：
  ```bash
  docker compose down -v --remove-orphans
  docker rm -f $(docker ps -aq)
  docker network prune -f
  docker volume prune -f
  ```

---

## 🗣️ 面試說法（你可以怎麼講）

> 我曾經實作過 NGINX 當作 Spring Boot 應用的反向代理，也處理過容器卡死的問題。  
> 過程中我學到 bind mount 會在 VirtualBox 下造成 zombie container，後來改用 Dockerfile + COPY 解法後完全穩定。  
> 我也處理過 AppArmor profile 殘留導致容器 permission denied 的問題，是透過 `aa-remove-unknown` 解鎖的。  
> 這讓我不只是能跑得起服務，也能在 container 死掉時找出真正原因。

---

## ✅ 恭喜完成 Day 48！

你已經學會：
- 建立反向代理結構
- 避免卡住的容器問題
- 解鎖 AppArmor 殘留資源

🔜 下一步是學會部署 Traefik + 自動路由註冊、Let's Encrypt 憑證整合！

