# [DevOps120-技術轉職] Day30：使用多重 Tag 同步推送 Docker 映像 🐳🔁🏷️

## 🎯 今日目標

學會在 Jenkinsfile 中一次為同一個 Docker 映像打上多個 tag 並同步推送，例如：

- `latest`
- `dev`
- `commit-hash`
- `build-流水號`

這讓映像在部署環境中更具彈性，也能保留精確的版本回溯能力。

---

## 🧠 為什麼要打多個 tag？

| Tag 類型      | 用途                                     |
|---------------|------------------------------------------|
| `latest`      | 預設 tag，方便快速拉取                  |
| `dev`, `prod` | 區分部署環境                            |
| `commit hash` | 精確對應 Git 狀態，支援追蹤與 rollback   |
| `v1.0.0`      | 可讀性高，版本升級管理                  |

🔍 多 tag 管理讓同一份映像在不同環境扮演不同角色。

---

## 🛠️ Jenkinsfile 推送多 tag 範例

```groovy
pipeline {
  agent any

  parameters {
    string(name: 'TAG', defaultValue: 'dev', description: '映像檔版本 Tag')
  }

  environment {
    IMAGE_REPO = 'yehweiyang/demo'
    DOCKERHUB_CREDENTIALS = 'docker-hub'
  }

  stages {
    stage('取得版本資訊') {
      steps {
        script {
          def commitHash = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          env.COMMIT_HASH = commitHash
          env.BUILD_TIME_TAG = "build-${env.BUILD_NUMBER}"
          env.LATEST_TAG = "${env.IMAGE_REPO}:latest"
          env.DEV_TAG = "${env.IMAGE_REPO}:${params.TAG}"
          env.HASH_TAG = "${env.IMAGE_REPO}:${commitHash}"
          env.BUILD_TAG = "${env.IMAGE_REPO}:${env.BUILD_TIME_TAG}"
        }
      }
    }

    stage('建構映像') {
      steps {
        sh './mvnw clean package -DskipTests'
        sh 'docker build -t $LATEST_TAG .'
        sh 'docker tag $LATEST_TAG $DEV_TAG'
        sh 'docker tag $LATEST_TAG $HASH_TAG'
        sh 'docker tag $LATEST_TAG $BUILD_TAG'
      }
    }

    stage('登入並推送') {
      steps {
        withCredentials([
          usernamePassword(credentialsId: "$DOCKERHUB_CREDENTIALS", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
        ]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
        }

        sh 'docker push $LATEST_TAG'
        sh 'docker push $DEV_TAG'
        sh 'docker push $HASH_TAG'
        sh 'docker push $BUILD_TAG'
      }
    }
  }

  post {
    success {
      echo '✅ 所有 tag 已成功推送'
    }
  }
}
```

---

## 📌 小提醒

- `docker tag` 不會重新建構映像，只是加上不同標籤
- 多 tag 可支援環境切換、版本對應、快速追蹤
- 推送前記得登入 Docker Hub，避免權限錯誤

---

## 🧑‍💼 面試官怎麼問？我會這樣回答：

> 這一天我學會了如何在 Jenkins 中對同一份 Docker 映像打上多個 tag，像是 `latest`、`dev`、Git commit hash、Build 編號等，並一次推送到 Docker Hub。  
> 這不只提升了版本辨識度，也讓我能在部署不同環境時有更多彈性，同時保留完整版本回溯與 rollback 的能力。  
> 多 tag 管理的概念也讓我更理解如何在 CI/CD 中做出真正可追蹤、可控制的映像策略。

---

