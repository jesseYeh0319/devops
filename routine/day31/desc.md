# 🧩 [DevOps140-技術轉職計畫]  
## Day 31：使用 post block 實作 Jenkins 建置結果通知與清理流程 📩🧹

---

## 🎯 今日目標

學會使用 Jenkins pipeline 的 `post` 區塊，實現建置完成後的通知與清理邏輯：

- 分類處理建置結果（success / failure / always）  
- 發送通知（Slack、Email、Log）  
- 執行清理作業（登出 Docker、刪除暫存）  
- 建立健壯穩定的 pipeline 架構  

---

## 🧠 理論解析：什麼是 post block？

`post` 是 Jenkins pipeline 中用來定義「建置後動作」的區塊，可以依據建置狀態執行不同處理：

```groovy
post {
  always {
    // 總是會執行（無論成功或失敗）
  }
  success {
    // 僅當建置成功才執行
  }
  failure {
    // 僅當建置失敗時執行
  }
  unstable {
    // 測試未通過但建置未失敗
  }
  aborted {
    // 被人手動中止
  }
}
```

---

## 🛠 Jenkinsfile 範例：整合 post block 實作

```groovy
pipeline {
  agent any

  environment {
    IMAGE_NAME = 'your-dockerhub-account/your-image-name:latest'
  }

  stages {
    stage('打包 Spring Boot 專案') {
      steps {
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('Docker login 並建置映像檔') {
      steps {
        script {
          withCredentials([usernamePassword(
            credentialsId: 'docker-hub-creds',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
          )]) {

