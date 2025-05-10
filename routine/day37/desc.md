# 🚀 DevOps140 技術轉職計畫：Day 37  
## 整合 GitHub Actions 與 Jenkins 雙向協作

---

### 🎯 今日目標

透過 GitHub Actions 執行 **CI 測試驗證**，確認程式碼穩定無誤後，再透過 `curl` 觸發 Jenkins 執行 **CD 自動建置／部署流程**，實現雙向串接的 DevOps 流程。

---

### 📌 架構概覽

```text
Developer Push Code (GitHub)
        │
        ▼
GitHub Actions 執行 CI 測試 (.mvnw test)
        │
        ├── ❌ 測試失敗：停止流程，不觸發 Jenkins
        │
        └── ✅ 測試成功：發送 curl 請求 → 觸發 Jenkins Webhook
                          │
                          ▼
                   Jenkins 進行 CD 流程
                   （建置、推送、部署）
```

---

### 🧩 GitHub Actions 設定檔 `.github/workflows/ci-and-deploy.yml`

```yaml
name: CI and Deploy

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build-and-trigger:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Build project
        run: ./mvnw clean verify

      - name: Trigger Jenkins job
        env:
          JENKINS_URL: ${{ secrets.JENKINS_URL }}
          JENKINS_TOKEN: ${{ secrets.JENKINS_TRIGGER_TOKEN }}
        run: |
          curl -X POST "$JENKINS_URL/generic-webhook-trigger/invoke?token=$JENKINS_TOKEN" \
            -H "Content-Type: application/json" \
            -d '{"from":"github-actions","branch":"${{ github.ref_name }}"}'
```

---

### 🛡️ GitHub Secrets 設定

請至 GitHub Repository →  
`Settings → Secrets and variables → Actions` 中新增以下兩組密鑰：

| 名稱 | 用途 |
|------|------|
| `JENKINS_URL` | Ngrok 對外可存取的 Jenkins URL，例如 `https://xxxx.ngrok.app` |
| `JENKINS_TRIGGER_TOKEN` | Jenkins Job 所設置的 Webhook Token，例如 `github-actions-token` |

---

### 🧪 Jenkins Job 設定

#### ✅ Job 類型：Pipeline（使用 `Jenkinsfile`）

#### ✅ Jenkinsfile 範例

```groovy
properties([
  pipelineTriggers([
    [$class: 'GenericTrigger',
      genericVariables: [
        [key: 'from', value: '$.from'],
        [key: 'branch', value: '$.branch']
      ],
      causeString: 'Triggered by $from via branch $branch',
      token: 'github-actions-token',
      printContributedVariables: true
    ]
  ])
])

pipeline {
  agent any

  stages {
    stage('Build Docker image') {
      steps {
        echo "📦 準備打包來自 $branch 分支的程式碼"
        sh './mvnw package -DskipTests'
        sh 'docker build -t my-image:latest .'
      }
    }
  }
}
```

---

### ✅ 成功驗證條件

1. 在 GitHub Actions 中看到 `build-and-trigger` 成功
2. Jenkins 對應 Job 有成功被觸發（例如 `demo-pipeline #13`）
3. Jenkins Console Output 顯示觸發原因：「Triggered by github-actions via branch main」

---

### 💡 面試口語化說法建議

> 我們有把 GitHub Actions 當成第一層 CI 驗證的守門員，只要測試通過才會進一步觸發 Jenkins 進行建置部署。這樣的流程設計可以先幫忙擋掉一些單元測試失敗或程式碼錯誤，讓 Jenkins Server 不會白跑，效能上也會比較省，而且責任劃分也更清楚。

---

### 🔚 小結

| 負責任務 | 工具 |
|----------|------|
| ✅ 單元測試 / 調用權限控管 | GitHub Actions |
| ✅ 建置 / 發布映像檔 / 自動部署 | Jenkins |

這樣就實現了 GitHub Actions + Jenkins 的雙向協作工作流 🎉


