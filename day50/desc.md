# 📦 [DevOps140] Day 50：封裝可攜式 Docker 專案模板

## ✅ 今日目標

- 封裝一份乾淨可複製的 Docker 專案骨架
- 建立標準化專案結構：Dockerfile、.env、compose、Makefile
- 加入 build / up / test 快速執行指令
- 提供 `.env.example` 範本供他人快速啟動
- 打包成 GitHub repo 讓面試時能快速展示

---

## 🧱 標準專案目錄結構

```
myapp/
├── app/                    # 應用程式原始碼
│   └── ...                
├── Dockerfile             # 建置 Spring Boot 或其他 app
├── docker-compose.yml     # 編排應用 + 資料庫等服務
├── .env                   # 實際執行用參數
├── .env.example           # 範本檔，避免誤上傳密碼
├── Makefile               # 提供快速指令（build, up, test）
└── README.md              # 專案說明與啟動方式
```

---

## 🐳 Dockerfile 範本（Spring Boot）

```Dockerfile
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package spring-boot:repackage -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 🧰 docker-compose.yml 範本

```yaml
services:
  app:
    build:
      context: .
    ports:
      - "${APP_PORT}:8082"
    environment:
      - SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}
    networks:
      - backend
  db:
    image: postgres:14
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - pg_data:/var/lib/postgresql/data
    networks:
      - backend

networks:
  backend:

volumes:
  pg_data:
```

---

## ⚙️ Makefile 範本

```Makefile
up:
	docker compose --env-file .env up -d --build

down:
	docker compose --env-file .env down -v --remove-orphans

logs:
	docker compose logs -f

build:
	docker compose build
```

---

## 🔑 .env.example

```env
APP_PORT=8082
SPRING_PROFILES_ACTIVE=dev

POSTGRES_DB=demo
POSTGRES_USER=demo
POSTGRES_PASSWORD=secret
```

> ✅ 加入 `.gitignore` 確保 `.env` 不會被意外 commit，但 `.env.example` 保留做參考

---

## 🗣️ 面試時可以這樣說：

> 我習慣將專案封裝成可攜式模板，包含 Dockerfile、.env 範例、Makefile、compose 編排與 README 說明。這樣能讓團隊成員快速啟動、複製或套用，也方便 CI/CD 整合或部署到雲端。這是我在實務中落實 DevOps 精神的重要一環。

---

## ✅ 結語

你現在具備一份可以上 GitHub 的：
- 可執行 + 可複製的 Docker 專案模板
- 自動 build + up 指令流程
- 符合開源慣例的結構與檔案

