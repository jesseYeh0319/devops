# 🚀 [DevOps140-技術轉職計畫] Day 42：瘦身映像，降低體積與快取設計

## 🎯 今日目標

學會如何設計 Dockerfile 以 **瘦身映像檔大小**，並搭配 **快取機制優化建置時間**。從理論到實作，掌握映像最佳化原則，打造輕巧、可維護的 CI/CD 容器環境。

---

## 📦 主題一：映像檔體積為什麼會變大？

- 安裝太多不必要的工具（例如 build 工具留在 runtime）
- Dockerfile 快取錯誤導致重建時累積多層
- 使用不必要的 base image（如 openjdk vs alpine）
- COPY 過多無用檔案（node_modules, .git, test data）
- 沒有使用 `.dockerignore` 排除多餘內容

---

## 🧠 主題二：映像瘦身的技巧

### ✅ 1. 使用多階段建置（multi-stage build）

```dockerfile
# build 階段
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# 運行階段
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### ✅ 2. 使用更小的 Base Image

- openjdk → eclipse-temurin / alpine
- node → node:alpine
- python → python:slim

### ✅ 3. 加入 `.dockerignore`

```dockerignore
.git
node_modules
target
*.md
Dockerfile.*
```

### ✅ 4. 清理暫存檔、apt cache 等（對非 multi-stage 可用）

```dockerfile
RUN apt-get update && apt-get install -y \
    curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
```

---

## ⚡ 主題三：快取設計與 Dockerfile 排序原則

### 原則：**越常變動的指令越往下排**

範例（差）：
```dockerfile
COPY . .
RUN npm install
```

範例（好）：
```dockerfile
COPY package*.json ./
RUN npm install
COPY . .
```

這樣能保留 `npm install` 的快取，不會因為 app code 變動就重跑。

---

## 🛠️ 今日任務實作

1. 找一份你自己的 Dockerfile
2. 重新改寫為 **multi-stage**
3. 加上 `.dockerignore`
4. 測量：
   - 修改前的映像大小
   - 修改後的映像大小
5. 用 `docker build --no-cache` 觀察建置時間差異

---

## 🗣️ 面試說法模板

> 「我們專案在建置 CI 映像時，初期檔案超過 800MB。後來我導入 multi-stage build，把 build 工具排除，最終減到 280MB 且保留快取效率。也有使用 .dockerignore 濾掉 git 目錄與中間編譯檔，讓推送上 Docker Hub 更快。」

---

## 🧩 延伸挑戰

- 嘗試用 `docker-slim` 自動瘦身
- 比較 alpine 與 debian base image 的體積與啟動速度差異
- 撰寫自動比對映像差異的 GitHub Action

---

## 📚 參考資源

- [Docker 官方最佳實踐](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Slim.AI 映像體積分析工具](https://www.slim.ai/)

