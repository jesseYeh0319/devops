# 🚀 DevOps140-技術轉職計畫：Day 36  
## 主題：串接 GitHub PR comment 觸發 Jenkins job

---

## 🎯 目標說明

今天的任務是透過 GitHub PR 上的留言指令（如 `/retest`、`/deploy`），自動觸發 Jenkins Job。

這種設計屬於 ChatOps 實作的一種形式，能讓團隊用留言來主動控制 CI/CD 流程，而非每次都得進 Jenkins UI 點擊操作。

---

## 🧰 需要的 Jenkins Plugin

- ✅ [Generic Webhook Trigger Plugin](https://plugins.jenkins.io/generic-webhook-trigger/)

---

## 🧪 Jenkinsfile 範例

```groovy
@Library('my-shared-lib') _

properties([
  pipelineTriggers([
    [$class: 'GenericTrigger',
      genericVariables: [
        [key: 'COMMENT', value: '$.comment.body'],
        [key: 'PR_NUMBER', value: '$.issue.number']
      ],
      causeString: 'Triggered on comment: $COMMENT',
      token: 'github-pr-comment-token',
      printContributedVariables: true,
      regexpFilterText: '$COMMENT',
      regexpFilterExpression: '^/(retest|deploy)$'
    ]
  ])
])

pipeline {
  agent any

  environment {
    IMAGE_REPO = 'yehweiyang/demo'
    DOCKERHUB_CREDENTIALS = 'docker-hub'
  }

  parameters {
    string(name: 'TAG', defaultValue: 'dev', description: '映像檔版本 Tag')
  }

  stages {
    stage('Triggered by PR comment') {
      steps {
        script {
          def comment = env.COMMENT?.trim()

          echo "👉 PR #${env.PR_NUMBER} 提出指令：${comment}"

          if (comment == "/retest") {
            echo "🔁 開始執行測試流程..."
          } else if (comment == "/deploy") {
            echo "🚀 執行部署流程中..."
          } else {
            echo "❌ 未支援的指令，跳過執行"
          }
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
        notifySlack("Build 成功", ":white_check_mark:")
      }
    }
    failure {
      script {
        notifySlack("Build 失敗，請立即檢查 Log ⚠️", ":x:")
      }
    }
  }
}
```

---

## 🌐 GitHub Webhook 設定

- **Payload URL：**

```
https://你的-ngrok-url/generic-webhook-trigger/invoke?token=github-pr-comment-token
```

- **Content Type：** `application/json`

- **Event 類型：**
  - 勾選 `Issue comments` ✅

---

## ⚠️ 必踩的坑：一定要先執行一次 Jenkins Job！

> Jenkins 只有在 Job 被手動執行過一次，才會讀取 Jenkinsfile 中的 `properties {

