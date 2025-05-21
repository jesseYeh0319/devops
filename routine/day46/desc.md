# 🚑 Day 46：設定 Healthcheck 確保容器穩定性

---

## 🎯 今日目標

- 理解 Docker 的健康檢查機制（`HEALTHCHECK`）
- 為 Spring Boot 應用設計容器層級的監測
- 實作健康檢查指令，確保容器不只是「啟動」，而是真的「可用」
- 實際排除因 Healthcheck 失敗導致容器卡死的錯誤案例

---

## ✅ 為什麼要設定 Healthcheck？

即使容器能成功啟動，也不代表內部的應用程式真的在正常運作。  
透過 `HEALTHCHECK` 指令，我們可以讓 Docker：

- 判斷容器內部服務是否存活（回應 200）
- 在多容器情境中，讓 `depends_on` 等待對方健康後再啟動
- 搭配 CI/CD 自動部署，判斷應用是否 ready

---

## 🔨 Dockerfile Healthcheck 實作範例（Spring Boot）

```dockerfile
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/demo.jar ./app.jar

# ✅ 加入 curl-based Healthcheck
HEALTHCHECK --interval=10s --timeout=3s --start-period=20s --retries=3 \
  CMD curl --fail http://localhost:8082/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 📦 docker-compose.yml 配置（.env.dev 環境）

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "${APP_PORT}:8082"
    depends_on:
      db:
        condition: service_healthy
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
    volumes:
      - ${DB_VOLUME_NAME}:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $${POSTGRES_USER}"]
      interval: 10s
      timeout: 3s
      retries: 3
    ports:
      - "5432:5432"
    networks:
      - backend

volumes:
  pg_data_dev:

networks:
  backend:
```

---

## 🧪 我實際遇到的錯誤狀況（debug 全紀錄）

### ❌ 問題 1：Healthcheck 一直回 404，導致 app 容器變 `unhealthy`

```bash
curl http://localhost:8082/actuator/health
# ➜ {"status":404,"error":"Not Found"}
```

### ✅ 解法：
在 Spring Boot 加上：

```properties
# application.properties
management.endpoints.web.exposure.include=health
```

或使用更穩定的自定義 endpoint：

```java
@RestController
public class PingController {
    @GetMapping("/ping")
    public String ping() {
        return "pong";
    }
}
```

```yaml
healthcheck:
  test: ["CMD", "curl", "--fail", "http://localhost:8082/ping"]
```

---

### ❌ 問題 2：容器卡死無法停止，即使用 `sudo docker rm -f` 也報 `permission denied`

```bash
docker rm -f demo-app-1
# ➜ could not kill: permission denied
```

### ✅ 解法：
完整重開 Docker Daemon 無效時，必須執行整台機器 reboot：

```bash
sudo reboot
```

然後再用：

```bash
docker rm -f demo-app-1
docker volume prune
```

---

### ❌ 問題 3：忘記加入 `restart: "no"`，導致異常容器重啟循環鎖死

```yaml
restart: always  # ❌ 千萬不要這樣寫（尤其是 dev 環境）
```

### ✅ 解法：
所有 `docker-compose.yml` 中的服務（包含 app 和 db）應都改為：

```yaml
restart: "no"
```

---

## 🗣️ 面試口語化說法建議

> 我在實作 Docker 部署時，會明確加入 Healthcheck 機制，例如使用 `/actuator/health` 或自訂 `/ping` endpoint，來幫助 CI/CD 流程精準判斷應用是否啟動完成。  
另外我也會避免在開發環境設定 `restart: always`，以免容器異常時進入重啟循環，造成難以停止的殭屍容器。這部分我曾實際處理過因 JDBC 卡住導致 app 無法關閉、必須重啟系統來清理的案例。

---

## 🧠 今日學到的知識

- `HEALTHCHECK` 可在 Dockerfile 中設計健康檢查流程
- Docker Compose 可使用 `depends_on.condition: service_healthy` 控制啟動順

