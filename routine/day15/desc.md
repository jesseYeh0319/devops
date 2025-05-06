```markdown
# DevOps120｜Day 15：Jenkins + Docker CI 整合實戰

## 🎯 今日目標

- Jenkins 透過 Docker 執行建置流程
- 使用 `mvn clean package` 建立 JAR
- 使用 `docker build` 建立映像檔
- Jenkins 容器內能執行 docker 指令

---

## 🛠️ 1. 啟動可操作 Docker 的 Jenkins 容器

停止原本 Jenkins 容器，重建並掛載 docker 套件與 socket：

```bash
docker stop jenkins
docker rm jenkins

docker run -d \
  --name jenkins \
  -u root \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /usr/bin/docker:/usr/bin/docker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

---

## 🏗️ 2. Jenkins Job：Git + Maven + Docker

在 Freestyle 專案中：

- Source Code Management：設定 GitHub 專案（內含 `pom.xml`、`Dockerfile`）
- Build Steps → Execute Shell 加入指令：

```bash
cd your-project-folder
mvn clean package
docker build -t demo-app .
```

（可加入 debug 指令）

```bash
pwd
ls -l
```

---

## 📦 3. 選配：推送至 Docker Hub

```bash
docker login -u $DOCKER_USER -p $DOCKER_PASS
docker tag demo-app yourname/demo-app:latest
docker push yourname/demo-app:latest
```

---

## ✅ 技術總結

| 技術項目           | 說明                                         |
|--------------------|----------------------------------------------|
| Docker socket 掛載 | 容器內 Jenkins 可控制主機 Docker            |
| `mvn package`      | Jenkins 編譯 Maven 專案                      |
| `docker build`     | Jenkins 製作映像檔，自動建構執行環境        |
| `docker push`      | Jenkins 推送映像檔到遠端倉庫（選配）         |
```

