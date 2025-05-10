# 🚀 [DevOps140-技術轉職計畫]  
## Day 34：封裝 Jenkinsfile 為 Shared Library 📦🧩

---

## 🎯 今日目標

將 Jenkinsfile 中重複出現的步驟，例如 Slack 通知、Docker 登出、建置流程，抽取成 Jenkins Shared Library，提升可讀性與維護性，並在多個 pipeline 專案間重複使用。

---

## 🔧 Jenkins Shared Library 核心觀念

### 🔹 什麼是 Shared Library？

Jenkins Shared Library 是一種 **集中管理共用 pipeline function 的機制**，讓你可以封裝 Groovy 邏輯後，在 Jenkinsfile 裡用：

```groovy
@Library('my-shared-lib') _
```

並直接呼叫 `notifySlack(...)` 等共用函式。

---

## 📁 Jenkins Shared Library 對應關係總整理

| 元素 | 說明 |
|------|------|
| `@Library('my-shared-lib')` | 指定要使用 Jenkins UI 設定中名稱為 `my-shared-lib` 的 Library |
| Jenkins UI → Library Name | 要與 `@Library()` 中名稱一致 |
| `vars/notifySlack.groovy` | Jenkins 自動轉成 `notifySlack(...)` 可呼叫函式 |
| `src/org/.../*.groovy` | 放共用類別，需 import 和 new 來使用 |
| `resources/*.json` 等 | 可用 `libraryResource(...)` 載入靜態檔案 |

---

## ❓ Q&A：剛剛實作中常見的問題

### ❓ Jenkinsfile 裡的 `@Library('my-shared-lib')` 是什麼？

✅ 它是「指向 Jenkins UI 中註冊的 Shared Library 名稱」，Jenkins 會從 UI 配好的 Git repo 中讀取 library 程式。

---

### ❓ 為什麼要把 `.groovy` 放在 `vars/` 裡？

✅ 只有放在 `vars/` 資料夾下的 `.groovy`，才會被 Jenkins 自動當作 pipeline 函式註冊進來。

舉例：放了 `vars/notifySlack.groovy`，你就可以在 Jenkinsfile 中呼叫 `notifySlack(...)`。

---

### ❓ 如果 `vars/` 中有多個檔案怎麼辦？

✅ 每個檔案會變成一個 pipeline 函式。範例如下：

```
vars/
├── notifySlack.groovy  →  notifySlack(...)
├── deployApp.groovy    →  deployApp(...)
├── buildJar.groovy     →  buildJar(...)
```

你不需要 import，不需要指定要載入哪個檔案，**Jenkins 會全部自動注入**。

---

### ❓ `vars/notifySlack.groovy` 裡面要怎麼寫？

```groovy
def call(String message, String emoji = ":rocket:") {
  withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_URL')]) {
    def payload = [
      text: "${emoji} Job: ${env.JOB_NAME} #${env.BUILD_NUMBER} ${message}\n👉 ${env.BUILD_URL}"
    ]
    writeJSON file: 'slack-payload.json', json: payload
    sh 'curl -X POST -H "Content-type: application/json" --data @slack-payload.json "$SLACK_URL"'
  }
}
```

---

## 🧪 Jenkinsfile 實作範例

```groovy
@Library('my-shared-lib') _

pipeline {
  agent any
  stages {
    stage('測試通知') {
      steps {
        script {
          notifySlack("🎉 測試成功")
        }
      }
    }
  }

  post {
    always {
      echo '🚧 清理資源中...'
      sh 'docker logout || true'
    }
    success {
      script {
        notifySlack("✅ Build 成功", ":white_check_mark:")
      }
    }
    failure {
      script {
        notifySlack("❌ Build 失敗，請檢查 Log", ":x:")
      }
    }
  }
}
```

---

## 🗣 面試口語化說法

>「我會把 Slack 通知這類重複性高的邏輯抽到 Jenkins Shared Library 中，像是放在 `vars/notifySlack.groovy`，就能用 `notifySlack(...)` 呼叫。這樣 Jenkinsfile 乾淨又可維護，也能在不同專案間重複使用，對 CI/CD 的擴展與團隊協作幫助很大。」

---

