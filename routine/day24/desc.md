# 🚀 DevOps120 - 技術轉職計畫：Day 24

## 🎯 主題：Jenkins 中整合 `.env` 與 Docker Compose 自動部署

---

## 📌 今日目標

- Jenkins Pipeline 能讀取 `.env` 並傳遞變數給 docker-compose  
- 撰寫 `docker-compose` 自動化部署流程（包含 build / up / down）  
- 支援 Jenkins 參數化選擇不同環境（.env.dev / .env.prod）  
- 讓部署指令在本地與 CI 環境都能共用與重複執行  

---

## 🛠️ 步驟一：準備多組 `.env` 檔案

在專案根目錄建立以下檔案：

```
.env.dev
.env.prod
.env.example
```

範例 `.env.dev`：

```env
APP_PORT=8080
DB_PORT=5432
SPRING_PROFILES_ACTIVE=dev
POSTGRES_DB=mydb
POSTGRES_USER=user
POSTGRES_PASSWORD=password
```

---

## 🛠️ 步驟二：修改 Jenkinsfile 加入部署流程

加入以下參數與環境控制邏輯：

```groovy
pipeline {
  agent any

  parameters {
    choice(name: 'ENV_FILE', choices: ['.env.dev', '.env.prod'], description: '選擇部署環境')
  }

  stages {
    stage('Build Image') {
      steps {
        sh 'docker-compose --env-file ${ENV_FILE} build'
      }
    }

    stage('Stop Existing Containers') {
      steps {
        sh 'docker-compose --env-file ${ENV_FILE} down'
      }
    }

    stage('Start Services') {
      steps {
        sh 'docker-compose --env-file ${ENV_FILE} up -d'
      }
    }
  }
}
```

---

## 🧪 測試與驗證

1. 在 Jenkins Job 中建立 Pipeline 類型任務  
2. 勾選「參數化建置」→ 增加 `ENV_FILE` 為選項參數  
3. 建置時選擇 `.env.dev` 或 `.env.prod`  
4. 確認：
   - Jenkins Console Output 有正確讀取 ENV_FILE  
   - 容器啟動後對應設定符合預期（如 port、資料庫名稱）

---

## 💬 面試應用說明與常見提問

### ✅ 我可以怎麼跟面試官說我學了什麼？

- 我學會了如何使用 Jenkins Pipeline 搭配 `.env` 與 `docker-compose`，實作不同環境的自動化部署。
- 我了解 Build、Down、Up 等流程在實務中如何切開階段操作，並用參數控制部署靈活性。
- 為了讓流程可共用，我學會了透過 `--env-file` 控制環境切換，並避免寫死配置。
- 我設計了可供團隊共用的 `.env.example`，確保不會將敏感資訊寫進 Git 版本庫。

---

### ❓ 面試常見提問（模擬）

**Q：你在 Jenkins + Docker 部署中，如何實作環境切換？**  
A：我會使用 `.env.dev` / `.env.prod` 等檔案搭配 `--env-file` 傳入 `docker-compose`，並在 Jenkins 透過參數化控制。

---

**Q：你怎麼確保 `.env` 沒有被 commit 到 Git？**  
A：我會把 `.env` 加入 `.gitignore`，改提供 `.env.example` 當模板。

---

**Q：你有遇過部署後沒變的情況嗎？你怎麼排查？**  
A：我知道 Docker Compose 會使用快取，所以我會加入 `--no-cache`，或確認 Jenkins 的 workspace 有正確 clean，避免跑到舊的 image。

---

**Q：為什麼不直接用 `docker run`，而選擇 `docker-compose`？**  
A：`docker-compose` 適合管理多個 container 的整體關係，例如 app + db，我可以一次啟動、一次部署，而且能整合 .env 實現參數化。

---

## 🎁 延伸挑戰（選做）

- 加入 Slack 通知部署成功與失敗  
- 在每次部署前自動備份舊容器 log  
- 將部署記錄寫入 GitHub release note 或 changelog.md

---

## 📚 小結

- Jenkins 可透過 `--env-file` 與 `docker-compose` 結合實作跨環境部署  
- `.env` 管理讓參數外部化，可快速切換開發／測試／正式環境  
- 避免寫死參數，讓部署流程具備彈性與可複用性  

