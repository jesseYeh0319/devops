# [DevOps120-技術轉職] Day28：建置與推送多版本映像檔（Tag 管理與版本化部署） 🏷️🐳

## 🎯 今日目標

學會在 Jenkinsfile 中使用參數與 Git 資訊，自動為 Docker 映像檔打上對應版本的 Tag，達成：

- 可辨識的映像版本（如 `1.0.0`, `dev-20240510`, `commit-hash`）
- 支援多環境部署（如 `latest`, `staging`, `prod`）
- 完整映像追蹤與回溯能力

---

## 🧩 為什麼 Tag 很重要？

在 CI/CD 中，「Tag 是唯一識別映像的方式」，如果只有 `latest`：

- 無法知道哪一版出錯
- 不方便 rollback
- 無法辨識環境版本（dev/test/prod）

---

## 🛠️ Tag 命名實務建議

| 類型       | 範例             | 說明                          |
|------------|------------------|-------------------------------|
| 靜態版本號 | `1.0.0`          | 固定版本，每次升版時更新     |
| 動態時間戳 | `dev-20240510`   | 結合環境與日期                |
| Git Commit | `sha-6e421af`    | 精確對應某次 commit           |
| 多重 Tag   | `latest`, `dev`  | 推同一映像到多個 tag          |

---

## 🧰 Jenkinsfile 參數化推送多版本範例

```groovy
pipeline {
  agent any

  parameters {
    string(name: 'TAG', defaultValue: 'dev', description: '映像檔版本 Tag')
  }

  environment {
    IMAGE_REPO = 'yehweiyang/demo'
    IMAGE_TAG = "${IMAGE_REPO}:${TAG}"
    DOCKERHUB_CREDENTIALS = 'docker-hub'
  }

  stages {
    stage('打包與建構') {
      steps {
        sh './mvnw clean package -DskipTests'
        sh 'docker build -t $IMAGE_TAG .'
      }
    }

    stage('登入並推送') {
      steps {
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
      echo "✅ 映像推送成功：$IMAGE_TAG"
    }
  }
}
```

---

## 🧠 小提醒

- 建議不要組成 `repo:tag1:tag2`，會出現 Docker 無效格式錯誤
- 可使用 dash（-）或 underscore（_）組合 tag 名稱
- 可用 `git rev-parse --short HEAD` 動態取得 commit hash 作為 tag

---

## 🧑‍💼 面試官怎麼問？我會這樣回答：

> 這一天我學會如何在 CI/CD 過程中針對 Docker 映像打上版本 Tag，例如透過 Jenkins 參數、Git commit hash 或日期組合，推送多個對應 tag（像是 `dev-20240510`, `v1.0.3`）。  
> 我理解到 tag 在部署上非常關鍵，它能讓團隊清楚追蹤是哪個版本部署到哪個環境，也能快速 rollback。這讓映像從「可執行」變成「可追蹤、可管理」。

---

