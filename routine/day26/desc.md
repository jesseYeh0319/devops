# [DevOps120-技術轉職] Day 26：封裝 Jenkinsfile 實作 CI 打包與推送流程 ☕🐳

## 🎯 今日目標

將 Day 25 所完成的部署流程，**全面整合進 Jenkinsfile（Declarative Pipeline）**，以實現穩定、可維護的 CI/CD 自動化。

---

## 📦 Jenkinsfile 完整範例

```groovy
pipeline {
  agent any

  environment {
    IMAGE_NAME = 'yehweiyang/demo:latest'
    DOCKERHUB_CREDENTIALS = 'docker-hub'
  }

  stages {
    stage('確認目錄') {
      steps {
        sh 'pwd && ls -al'
      }
    }

    stage('檢查環境') {
      steps {
        sh 'java -version'
        sh './mvnw -version'
      }
    }

    stage('打包專案') {
      steps {
        sh './mvnw clean package -DskipTests'
        sh 'ls -lh target/*.jar'
      }
    }

    stage('建構 Docker 映像檔') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('登入 Docker Hub') {
      steps {
        withCredentials([
          usernamePassword(
            credentialsId: "$DOCKERHUB_CREDENTIALS",
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
          )
        ]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
        }
      }
    }

    stage('推送 Docker 映像檔') {
      steps {
        sh 'docker push $IMAGE_NAME'
      }
    }
  }

  post {
    success {
      echo '✅ 部署流程成功完成'
    }
    failure {
      echo '❌ 發生錯誤，請查看日誌'
    }
  }
}
```

---

## 🧠 重點提示

- ✅ 使用 `./mvnw` 確保 Maven 版本一致性
- ✅ 使用 Jenkins Credential 機制，自動注入帳密登入 Docker Hub
- ✅ `IMAGE_NAME` 採用 `帳號/映像檔:標籤` 格式，例如 `yehweiyang/demo:latest`
- ✅ 推送映像檔前，務必完成登入並確認權限
- ❗ 若 Jenkins 本身也是容器，請確認 Docker socket 有正確掛載

---

## 🧪 今日練習任務

1. 🔧 建立新的 Pipeline Job，來源設為 GitHub 專案
2. ✅ 將上方 Jenkinsfile 加入至 Git 專案，提交並 push
3. 🚀 執行 Jenkins Job，確認是否成功完成建構與推送

---

## 📚 延伸學習建議

- Jenkins Pipeline 教學：[https://www.jenkins.io/doc/book/pipeline/](https://www.jenkins.io/doc/book/pipeline/)
- Docker login + push 安全機制說明
- Jenkins Credentials 管理策略（建議用 Folder scope 避免誤用）

---

