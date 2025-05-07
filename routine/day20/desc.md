🚀 DevOps120 - 技術轉職計畫：Day 20

🎯 主題：Jenkins 參數化 Pipeline（Parameterized Builds）

📌 今日目標：
1. 建立可傳入參數的 Jenkins Pipeline 任務
2. 瞭解 parameters 區塊的使用方式與意義
3. 學會如何在不同 stage 中使用參數來控制流程

🛠️ 步驟 1：建立 Jenkins Pipeline 任務
1. Jenkins 首頁 → New Item（新建任務）
2. 命名（例如：param-demo）→ 選擇 Pipeline
3. 可選：勾選 This project is parameterized（實務上建議直接用 Jenkinsfile 定義）
4. 點選 Add Parameter，常見類型如下：
   - String Parameter：文字輸入
   - Choice Parameter：下拉選單
   - Boolean Parameter：布林勾選（預設值透過勾選框決定）

🛠️ 步驟 2：設定 Git 資訊與 Jenkinsfile 來源
1. Definition：Pipeline script from SCM
2. SCM：Git
3. Repository URL：例如 https://github.com/jesseYeh0319/demo.git
4. Credentials：若為私有庫，需選擇 PAT 認證
5. Branches to build：填寫 */main 或實際分支
6. Script Path：
   - 若 Jenkinsfile 放在根目錄，填 Jenkinsfile
   - 若放在 ci/ 資料夾，填 ci/Jenkinsfile

🧪 Jenkinsfile 範例（支援參數與條件邏輯）

pipeline {
    agent any

    parameters {
        string(name: 'USERNAME', defaultValue: 'weiyang', description: '使用者名稱')
        choice(name: 'ENV', choices: ['dev', 'test', 'prod'], description: '部署環境')
        booleanParam(name: 'SKIP_TESTS', defaultValue: true, description: '是否跳過測試階段')
    }

    stages {
        stage('顯示參數') {
            steps {
                echo "USERNAME = ${params.USERNAME}"
                echo "ENV = ${params.ENV}"
                echo "SKIP_TESTS = ${params.SKIP_TESTS}"
            }
        }

        stage('測試') {
            when {
                expression { return !params.SKIP_TESTS }
            }
            steps {
                echo "🧪 執行測試流程"
            }
        }

        stage('部署') {
            steps {
                echo "🚀 部署至 ${params.ENV} 環境完成"
            }
        }
    }
}

🧭 執行流程：
1. 進入 Jenkins 專案頁面，點選左側 Build with Parameters
2. 輸入參數內容或使用預設值，點選 Build
3. 點進建置編號 → Console Output 檢查是否正確帶入參數

💡 補充重點：
- Jenkinsfile 裡定義的 parameters 可自動產生 UI 參數表單
- 使用 params.<變數名> 方式在任意 stage 中取得參數值
- Boolean 參數預設值為 true → Jenkins UI 預設為勾選，false 則不勾選
- 可搭配部署環境選擇、跳過測試、開關功能模組等用途

