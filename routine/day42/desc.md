# 🚀 DevOps140 - 技術轉職計畫  
## Day 42：瘦身映像，降低體積與快取設計 🧹🐋

---

## ✅ 今日目標

- 建立乾淨、體積最小化的 Docker 映像
- 使用 BuildKit 快取 Maven `.m2/repository`，避免每次重複下載依賴
- 熟悉 Docker Layer 快取與失效原則，精準控制哪些層會重建
- 優化 Dockerfile 撰寫順序，提升建置效率

---

## 🐘 映像肥大的常見原因

| 問題來源 | 造成的影響 |
|----------|------------|
| 單階段建構，整包專案複製 | 包含原始碼與開發工具，映像龐大 |
| 未分離建構與執行階段 | Maven CLI、JDK 也被打包進去 |
| 每次建置都重新下載依賴 | 浪費時間與網路資源 |
| 缺少 `.dockerignore` 設定 | `.git/`、IDE 設定、log 等被誤包入 |

---

## ✅ 解法一：使用多階段建構（multi-stage build）

```dockerfile
# 🏗️ 建構階段
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package spring-boot:repackage -DskipTests

# 🚀 執行階段
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

> ✅ 最終映像中僅包含 `JRE` + `app.jar`，原始碼與建構工具皆不會被打包進去

---

## ✅ 解法二：啟用 BuildKit 快取 `.m2` 依賴

請使用以下指令來啟動建構流程：

```bash
DOCKER_BUILDKIT=1 docker build -t myapp:latest .
```

Dockerfile 中需加入以下內容：

```dockerfile
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline -B
```

> 🧠 此方式會在建構階段掛載一個快取資料夾，Maven 不會每次都重新下載依賴。

---

## 🔍 快取命中與失效時機

| 行為                        | 是否會重新下載 `.jar` | 說明 |
|-----------------------------|------------------------|------|
| `pom.xml` 有修改            | ✅ 會                   | 依賴可能改變，需重新下載 |
| `.mvn/` 或 `mvnw` 有變更    | ✅ 會                   | Maven wrapper 設定變更 |
| `src/` 程式碼變更           | ❌ 不會                 | 不影響依賴快取，只影響編譯 |
| 清除 BuildKit 快取資料夾    | ✅ 會                   | 快取不存在，自然重抓 |
| 更換建構主機或 CI 節點      | ✅ 會                   | 快取為本機性質，不會自動同步 |
| 快取有效且未變更依賴        | ❌ 不會                 | 完全命中快取，建構速度飛快 |

---

## 🗂️ 建議使用的 `.dockerignore`

```
.git
.idea
target
*.log
.env
*.iml
```

> ✅ 可避免將版本控制資料、IDE 設定檔、編譯產物等非必要資料打包進映像中。

---

## 🎯 面試口語化說法

>「我會使用 Docker 多階段建構技術，把建構過程與執行環境拆開，並透過 BuildKit 的 cache 掛載方式快取 Maven 的依賴檔案。這樣可以確保 `.jar` 只在首次下載，後續即使修改原始碼也能維持極快的建構效率。此外我會善用 `.dockerignore` 控制建構上下文內容，確保映像輕量、乾淨、無洩漏風險，實作上可穩定維持在 100MB 以內。」

---

## ✅ 今日成果驗收清單

- [x] 使用 BuildKit 成功掛載並快取 `.m2` 依賴
- [x] `app.jar` 成功打包為可執行 Fat JAR
- [x] 映像體積降低至 < 150MB
- [x] 建構時間從初次的 150+ 秒降至後續的 < 10 秒
- [x] 確認映像中無原始碼、Maven CLI 或多餘檔案

---

## 📚 延伸閱讀與工具參考

- [Docker 官方 BuildKit 快取教學](https://docs.docker.com/build/cache/)
- [Spring Boot 官方 Docker 實作指南](https://spring.io/guides/topicals/spring-boot-docker)
- `jar tf app.jar` 可用來檢視 Fat JAR 結構
- `docker builder prune` 清除快取資料（需謹慎使用）

---
