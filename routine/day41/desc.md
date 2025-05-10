# 🚀 DevOps140 - 技術轉職計畫  
## Day 41：多階段 Dockerfile 建構最佳化 🐳✨

---

## ✅ 今日目標

- 理解什麼是多階段建構（multi-stage build）
- 實作可用於 Spring Boot 的最佳化 Dockerfile
- 掌握「瘦身映像 + 快取打包」的技巧與關鍵原則

---

## 📦 為什麼需要多階段建構？

| 問題 | 單階段建構會遇到什麼？ |
|------|------------------------|
| 映像體積太大 | 包含 Maven CLI、原始碼、target 中間產物 |
| 安全性風險 | 原始碼、Git 記錄、密碼檔可能被打包進去 |
| 部署不純淨 | build 工具與執行環境混在一起 |

➡️ **多階段建構可以只取出乾淨的 `.jar` 成品，丟進純執行用的 JRE 容器中。**

---

## 🧱 多階段建構最佳實作範例（Spring Boot 專案）

```dockerfile
# ⚙️ 建立階段：用來打包 jar
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY .mvn/ .mvn/
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package spring-boot:repackage -DskipTests

# ▶️ 運行階段：只有乾淨的執行環境 + jar
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 💡 快取技巧補充（可選）

- 使用 `--mount=type=cache,target=/root/.m2` 快取 Maven 依賴（Docker BuildKit 支援）
- 拆開 `COPY` 的順序，讓 `pom.xml` 與 `src/` 分層處理，提升快取命中率

---

## 🎯 口語化面試說法：

>「我會使用多階段 Dockerfile，把 Maven 打包階段與執行階段分開。這樣不會把原始碼、建構工具、.git 等資訊打包進去映像，映像體積會從 500MB 降到 100MB 以下，也更安全、更快啟動、更適合用於 CI/CD。」

---

## ✅ 成果驗收：

- [x] 成功 build 出兩階段的映像檔  
- [x] 運行階段中無原始碼、無 Maven CLI  
- [x] 可用 `docker run` 執行並驗證 app.jar 運作正常

---

## 📚 延伸閱讀：

- [Docker 官方：多階段建構](https://docs.docker.com/develop/develop-images/multistage-build/)
- [Spring Boot Docker 指南](https://spring.io/guides/topicals/spring-boot-docker)

---

