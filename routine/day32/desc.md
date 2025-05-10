# 📣 [DevOps140-技術轉職計畫]  
## Day 32：Jenkins 加入 Slack 通知機制 📨🤖

---

## 🎯 今日目標

學會在 Jenkins pipeline 中整合 Slack 通知，能在建置成功、失敗、錯誤發生時即時傳送訊息給團隊：

- 建立 Slack App 並產出 webhook URL  
- Jenkins 設定 Slack 憑證  
- Jenkinsfile 中撰寫 Slack 發送指令  
- 使用 `post` block 條件式發送通知  

---

## 🧠 Slack 整合流程（步驟概要）

### 步驟 1：建立 Slack Webhook

1. 前往 [Slack Incoming Webhook](https://api.slack.com/messaging/webhooks)
2. 建立一個 App → 選擇你要通知的頻道 → 產生 webhook URL
3. 範例格式：  
   `https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX`

---

### 步驟 2：在 Jenkins 新增 Slack Webhook 憑證

1. Jenkins → Manage Jenkins → Credentials → Global
2. 類型選擇「Secret Text」
3. ID：`slack-webhook-url`，內容貼上 webhook URL

---

### 步驟 3：Jenkinsfile 中發送 Slack 訊息（可執行版本）

```groovy
post {
  success {
    script {
      withCredentials([string(credentialsId: 'slack-webhook-url', variable: 'SLACK_URL')]) {
        def message = """
        {
          "text": ":white_check_mark: Jenkins 任務成功 🎉\\nJob: ${env.JOB_NAME}\\nBuild: #${env.BUILD_NUMBER}\\nURL: ${env.BUILD_URL}"
        }
        """
        writeFile file: 'slack-payload.json', text: message
        sh 'curl -v -X POST -H "Content-type: application/json" --data @slack-payload.json "$SLACK_URL"'
      }
    }
  }

  failure {
    script {
      withCredentials([string(credentialsId: 'slack-webhook-url', variable: 'SLACK_URL')]) {
        def message = """
        {
          "text": ":x: Jenkins 任務失敗 ⚠️\\nJob: ${env.JOB_NAME}\\nBuild: #${env.BUILD_NUMBER}\\nURL: ${env.BUILD_URL}"
        }
        """
        writeFile file: 'slack-payload.json', text: message
        sh 'curl -v -X POST -H "Content-type: application/json" --data @slack-payload.json "$SLACK_URL"'
      }
    }
  }
}
```

---

## ✅ 實作任務

- [ ] 在 Slack 上收到 Jenkins 成功與失敗通知  
- [ ] 顯示建置資訊：Job 名稱、編號、URL、結果 Emoji  
- [ ] 使用 Jenkins Credentials 安全儲存 webhook

---

## 🗣 面試口語化心得說法

>「我會把 Jenkins pipeline 的通知整合進 Slack，像是建置成功就發白勾勾訊息、失敗就用紅叉。Webhook 會透過 Jenkins Credentials 儲存，避免裸露憑證。也會搭配 post block，根據成功或失敗做不同通知。這樣不只提升可觀測性，也能讓團隊在第一時間回應建置狀態。」

---

## 📚 延伸補充

- Slack webhook 官方說明：<https://api.slack.com/messaging/webhooks>
- Jenkins 插件（Slack Notifier Plugin）也可選用，但彈性較低
- 建議搭配內建變數如 `env.JOB_NAME`、`env.BUILD_URL` 產出更完整通知內容

