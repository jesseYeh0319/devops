DevOps120 - 技術轉職計畫：Day 21

🎯 主題：Jenkins Job 通知整合與部署追蹤（Slack / Line Notify）

📌 今日目標：
1. 在 Jenkins Job 中加入通知機制（成功、失敗、異常皆通知）
2. 整合 Slack 或 Line Notify，接收建置狀態更新
3. 學會使用 post block 中的 success、failure、always 條件
4. 實作 Job 結束時自動通報建置狀態

🧱 Jenkinsfile - Slack Webhook 通知範例

pipeline {
    agent any

    environment {
        SLACK_WEBHOOK_URL = credentials('slack-webhook')
    }

    stages {
        stage('建置') {
            steps {
                echo '🔧 開始建置應用程式...'
                // 模擬錯誤測試失敗通知
                // error("模擬錯誤發生")
            }
        }

        stage('部署') {
            steps {
                echo '🚀 正在部署至環境...'
            }
        }
    }

    post {
        success {
            echo '✅ 建置成功，發送 Slack 成功通知'
            sh """
            curl -X POST -H 'Content-type: application/json' \
              --data '{"text":"✅ Jenkins 建置成功！"}' \
              ${SLACK_WEBHOOK_URL}
            """
        }

        failure {
            echo '❌ 建置失敗，發送 Slack 失敗通知'
            sh """
            curl -X POST -H 'Content-type: application/json' \
              --data '{"text":"❌ Jenkins 建置失敗，請立即查看！"}' \
              ${SLACK_WEBHOOK_URL}
            """
        }

        always {
            echo '📬 Job 結束，進入 post 區塊'
        }
    }
}

🔧 Slack Webhook 設定方式

1. 登入 Slack，進入 https://api.slack.com/apps
2. 建立 App → 啟用 Incoming Webhooks
3. 新增 Webhook 並綁定頻道，取得網址
4. 到 Jenkins → Manage Jenkins → Credentials
5. 新增一筆 Secret Text，ID 命名為 slack-webhook，內容為 Webhook URL

📦 測試方式建議

- 可以在測試階段使用 error("fail") 來觸發 failure 通知
- 可搭配 post { always } 確保每次建置結尾都能偵測到 webhook

🧠 小提醒

- post block 的條件 success / failure / always 彼此獨立
- Slack Webhook URL 建議透過 credentials 注入，避免寫死在 Jenkinsfile 中
- 若沒有進入 post block，請確認是否清空 workspace，並確保最新 Jenkinsfile 被使用

