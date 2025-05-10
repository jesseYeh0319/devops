# 🧑‍⚖️ [DevOps140-技術轉職計畫]  
## Day 35：使用 input block 加入人工審核節點 ✋✅

---

## 🎯 今日目標

學會使用 Jenkins Pipeline 的 `input` block，在流程中插入人工審核節點，例如在部署到正式環境前，需經過人工確認後才能繼續。

---

## 📦 input block 是什麼？

`input` block 是 Jenkins 提供的互動式 pipeline DSL，用來：

- 停下流程，等待人工操作
- 接收輸入欄位（選單 / 文字）
- 指定誰可以操作（`submitter`）

---

## 🛠️ 基本語法：人工放行

```groovy
stage('部署前審核') {
  steps {
    script {
      input message: '主管請審核', submitter: 'admin,dev-lead'
    }
  }
}
```

這段會在 Jenkins Console 顯示審核介面，僅 `admin` 或 `dev-lead` 能點選「Proceed」。

---

## ⏱️ 防呆加強：加入 timeout

```groovy
stage('部署前審核') {
  steps {
    script {
      timeout(time: 30, unit: 'MINUTES') {
        input message: '主管請審核', submitter: 'admin,dev-lead'
      }
    }
  }
}
```

超過 30 分鐘沒審核，會自動中止 pipeline。

---

## 🧩 高階互動：加入欄位選單 + 傳回值

```groovy
stage('部署確認') {
  steps {
    script {
      def result = input(
        id: 'ApprovalInput',
        message: '請選擇要部署的環境',
        parameters: [
          choice(name: 'ENV', choices: ['staging', 'production'], description: '請選擇部署環境'),
          string(name: 'REASON', defaultValue: '例行部署', description: '請填寫說明')
        ]
      )

      def targetEnv = result['ENV']
      def reason = result['REASON']

      echo "選擇環境：${targetEnv}"
      echo "說明內容：${reason}"
    }
  }
}
```

---

## 🧠 實務注意事項

| 項目 | 說明 |
|------|------|
| `input` 需 Web UI 點選 | 無法用 API / CLI 模擬 |
| 建議搭配 `timeout` 避免卡死 | 實務中很常發生 |
| `submitter` 要用帳號 ID | 不是顯示名稱，區分大小寫 |
| 不能在 parallel block 中用 input | 會造成 workflow 無法解析 |

---

## 🗣️ 面試口語說法

>「我在部署前會用 Jenkins 的 `input` block 插入人工審核機制。像 production 環境我會加上 `submitter` 限定主管才能批准，並用 `timeout` 降低卡住風險。也會加上欄位讓 reviewer 選部署環境、填寫原因，方便審計與追蹤，這些都是 DevOps 實務中的流程把關點。」

---

## 🔚 小結

`input` block 是最基本的人工互動方式，適合保守控管環境使用。不過若要升級，可考慮：

- Slack 審核機制
- PR 驗證流程（GitOps）
- webhook + backend API 審批流程

這些才是更符合 DevOps 自動化精神的方向。

