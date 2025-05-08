# DevOps120 - 技術轉職 Day 25：使用 Jenkins 搭配機密憑證部署 Docker 環境 🐳🔐

## ✅ 今日目標

學會在 Jenkins pipeline 中整合密碼管理（如資料庫密碼）、讀取 `.env` 檔案進行參數化部署，並透過 Docker Compose 自動化啟動服務。

---

## 🧱 核心實作內容

### 1️⃣ 建立 Credentials

- 在 Jenkins → `Manage Jenkins` → `Credentials` 中新增：
  - 類型：`Secret text`
  - ID：`db-password`
  - 內容：資料庫密碼

### 2️⃣ Jenkinsfile 範例

```groovy
pipeline {
  agent any

  parameters {
    choice(name: 'ENV_FILE', choices: ['.env.dev', '.env.prod'], description: '選擇部署環境')
  }

  stages {
    stage('使用機密') {
      steps {
        withCredentials([string(credentialsId: 'db-password', variable: 'DB_PASS')]) {
          sh 'echo 資料庫密碼為：$DB_PASS'
        }
      }
    }

    stage('Build Image') {
      steps {
        echo '✅ Build Image'
        sh 'docker-compose --env-file ${ENV_FILE} build'
      }
    }

    stage('Stop Existing Containers') {
      steps {
        echo '✅ Stop Existing Containers'
        sh 'docker-compose --env-file ${ENV_FILE} down'
      }
    }

    stage('Start Services') {
      steps {
        echo '✅ Start Services'
        sh 'docker-compose --env-file ${ENV_FILE} up -d'
      }
    }
  }
}
```

---

## 🧪 測試技巧

- 測試前可透過 `docker-compose --env-file .env.dev config` 檢查組態是否正確
- 若出現 `permission denied`，檢查 Jenkins user 是否能控制 `/var/run/docker.sock`
- 建議在 Jenkins CI 容器中使用 `docker exec -u root -it jenkins-ci bash` 加入正確 GID

---

## 💡 面試時可以這樣說

- 我有實作 Jenkins Job 使用憑證自動部署，並控制部署環境與 Docker Compose 變數。
- 為確保安全，我將 DB 密碼存於 Jenkins Credentials，以避免硬編碼。
- 並搭配 `.env.dev` 或 `.env.prod` 設定不同環境的參數化部署，提升 CI 的可控性與安全性。

---

## 📝 備註

- 若使用 docker-compose v2，可改用 `docker compose` 語法
- 若 Jenkins container 權限不足，需手動將 `jenkins` user 加入正確 GID 的 `docker` 群組

```bash
# 主機上查詢 docker.sock 的 GID
stat -c '%g' /var/run/docker.sock

# Dockerfile 中建立對應群組
groupadd -g 124 docker && usermod -aG docker jenkins
```

---

