# [DevOps120-技術轉職] Day29：整合 Git Commit Hash 作為映像版本標籤 🔖🔁

## 🎯 今日目標

學會如何在 Jenkins Pipeline 中自動抓取 Git commit hash，並用作 Docker 映像的版本 tag，實現：

- 每次部署都對應到明確的程式碼版本  
- 可追蹤、可回溯、可還原  
- 無需手動命名 tag，自動化程度更高

---

## 🧠 為什麼使用 Git commit hash 當映像 tag？

| 傳統方式       | 問題點                               |
|----------------|------------------------------------|
| 使用 `latest`  | 無法分辨哪次 commit 對應哪個映像    |
| 手動輸入 tag   | 容易出錯、不一致、無法自動化         |
| 使用 commit hash | 每次建置都唯一對應一筆 commit，清晰可追蹤 ✅ |

---

## 🔧 指令說明

```bash
git rev-parse --short HEAD
```

會回傳目前 commit 的短哈希值，例如 `6e421af`，這個值可作為映像版本 tag。

---

## 🛠️ Jenkinsfile 實作範例

```groovy
pipeline {
  agent any

  environment {
    IMAGE_REPO = 'yehweiyang/demo'
    DOCKERHUB_CREDENTIALS = 'docker-hub'
  }

  stages {
    stage('取得 Commit Hash') {
      steps {
        script {
          COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          IMAGE_TAG = "${IMAGE_REPO}:${COMMIT_HASH}"
          env.IMAGE_TAG = IMAGE_TAG
          echo "🔖 使用映像版本：${IMAGE_TAG}"
        }
      }
    }

    stage('打包與推送映像') {
      steps {
        sh './mvnw clean package -DskipTests'
        sh 'docker build -t $IMAGE_TAG .'

        withCredentials([
          usernamePassword(credentialsId: "$DOCKERHUB_CREDENTIALS", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
        ]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
        }

        sh 'docker push $IMAGE_TAG'
      }
    }
  }

  post {
    success {
      echo '✅ Build & Push 完成：$IMAGE_TAG'
    }
  }
}
```

---

## 🧑‍💼 面試官怎麼問？我會這樣回答：

> 這一天我學會了如何將 Git commit hash 作為 Docker 映像的版本標籤，自動整合進 Jenkins Pipeline。  
> 相較於手動命名或使用 `latest`，commit hash 能確保每次部署都可準確對應回原始程式碼，這對錯誤追蹤與版本回滾非常重要。  
> 尤其在多人協作與自動部署的流程中，這種方式可以大幅提升可追蹤性與可靠性。

---

