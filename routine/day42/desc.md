# 🚀 DevOps140 - 技術轉職計畫  
## Day 42：瘦身映像，降低體積與快取設計 🧹🐋

---

## ✅ 今日目標

- 建立最小化、乾淨的 Docker 映像
- 使用 BuildKit 快取 Maven `.m2/repository`，避免每次重抓 `.jar`
- 熟悉 Layer 快取與失效原則，精準控制哪些動作會重新執行
- 學會調整 Dockerfile 結構提升快取命中率

---

## 📦 問題背景：為什麼我的映像這麼大？

| 問題來源 | 後果 |
|----------|------|
| 單階段建構（整包複製） | 映像體積大 + 安全風險 |
| Maven CLI、原始碼、target 一起被打包 | 效能慢、包含敏感內容 |
| 每次 build 都重抓 jar | 构建速度超慢 |
| 沒有 `.dockerignore` | `.git/`、IDE、log 被打包進 image |

---

## ✅ 解法一：使用多階段建構（multi-stage）

```dockerfile
# 建構階段
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package spring-boot:repackage -DskipTests

# 運行階段
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

> ✅ 注意：只有 `COPY pom.xml` 前的 Layer 才能命中 jar 快取  
> ✅ 最終映像只保留 `JRE` + `app.jar`，其他一律不保留

---

## ✅ 解法二：啟用 BuildKit 快取 `.m2`

執行 build 時使用以下指令：

```bash
DOCKER_BUILDKIT=1 docker build -t myapp:latest .
```

搭配 Dockerfile 中這段指令：

```dockerfile
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline -B
```

> ✅ 這會掛載一個可重用的快取資料夾，讓 jar 不會每次都重抓

---

## 🔍 快取原則與失效條件

| 行為                        | 是否影響 jar 下載？ | 原因說明 |
|-----------------------------|---------------------|----------|
| `pom.xml` 內容有變          | ✅ 是               | Maven 依賴有可能不同 |
| `.mvn/` 或 `mvnw` 變動     | ✅ 是               | Maven wrapper 設定變了 |
| `src/` 改動                 | ❌ 否               | 不影響依賴，只影響編譯 |
| 清除 BuildKit 快取          | ✅ 是               | Cache 被清空 |
| 換 CI 節點或換主機          | ✅ 是               | 快取綁定在本機 |
| 快取正確 + 無變動           | ❌ 否               | 快取成功命中，秒建！

---

## 🗂️ `.dockerignore` 範本建議

```
.git
.idea
target
*.log
*.iml
.env
```

> ✅ 避免把 Git 記錄、開發工具、編譯產物打進 image

---

## 🎯 面試口語化說法：

>「我會用多階段建構讓 Maven 打包階段與執行階段分離，搭配 BuildKit 的 `--mount=type=cache` 快取 Maven 依賴。這樣 jar 只會下載一次，後續 build 都能秒建，這在 CI/CD pipeline 中尤其有效。再加上 `.dockerignore` 控制 context 乾淨，最終映像也能維持在 100MB 以內，符合實務部署需求。」

---

## ✅ 今日成果驗收

- [x] 映像中不含原始碼與 Maven CLI
- [x] `.jar` 僅重新編譯、無需重抓依賴
- [x] 映像體積大幅縮減（通常 < 150MB）
- [x] build 時間從 160 秒降至 10 秒以內（快取成功）

---

## 📚 延伸閱讀與工具

- [Docker BuildKit 官方說明](https://docs.docker.com/build/cache/)
- [Spring Boot Docker 建構最佳實踐](https://spring.io/guides/topicals/spring-boot-docker)
- `jar tf app.jar` 查看 Fat JAR 結構
- `docker builder prune` 清除 BuildKit 快取（⚠️ 謹慎使用
