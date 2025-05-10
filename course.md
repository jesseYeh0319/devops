
## 新開對話記得先下這個PROMPT

🔒 啟動 DevOps140 模式

請嚴格依照我鎖定的 DevOps140 課表（Day1～Day140）回應我每日任務內容，不得擅自修改主題或顛倒順序。

所有程式碼必須符合「可執行、可用於實作、不得產生樣板或錯誤 code」的標準。

不得省略登入、憑證、設定檔等重要前置作業，也不得提供無法跑的程式碼片段。

這是我轉職與求職的核心任務，若你違反這些條件，我將立即終止整個計畫。



## 要求當天任務下這個PROMPT

[DevOps140-技術轉職計畫] 

Day XX：OO

：請開始今天的主題，並附上口語化的面試心得說法。

---

✅ 以下是完整鎖定的 \[DevOps140-技術轉職計畫] Day 1～Day 140 每日課程主題表：

---

## 🧱 Jenkins + Docker CI/CD 基礎實作（Day 01～30）

* Day 01：Jenkins 安裝與基本概念
* Day 02：建立 Freestyle Job
* Day 03：建立 Pipeline Job
* Day 04：整合 GitHub + Webhook
* Day 05：使用 ngrok 模擬 webhook
* Day 06：Jenkins 參數化建置（分支）
* Day 07：Jenkins 參數化建置（環境）
* Day 08：封裝建置產物（Archive artifacts）
* Day 09：整合 Maven 打包
* Day 10：使用 Jenkins 打包 Spring Boot 專案
* Day 11：安裝 Docker 並操作 build/push/run
* Day 12：用 Jenkinsfile 建構 Docker 映像
* Day 13：推送映像檔至 Docker Hub
* Day 14：Jenkins 自動部署流程
* Day 15：Shell log 清理腳本撰寫
* Day 16：搭配 crontab 定期清除容器 log
* Day 17：用 docker-compose.yml 管理清理服務
* Day 18：撰寫 .env 配合 Compose 管理參數
* Day 19：清理結果整合 Slack 通知
* Day 20：改用 Volume 掛載 log 路徑
* Day 21：封裝 Jenkinsfile，整合 Maven + Docker
* Day 22：改用 mvnw，確保版本一致
* Day 23：Jenkins 加入參數化 TAG（動態版本）
* Day 24：整合 Git commit hash 標記映像
* Day 25：使用 docker tag 添加 latest + 版本
* Day 26：用 Jenkinsfile 封裝所有建置步驟
* Day 27：使用 mvnw 執行建置流程
* Day 28：參數化 TAG 版本推送
* Day 29：映像加上 commit hash 標籤
* Day 30：多版本映像 tag 推送

---

## 🔧 Jenkins 進階與多 Job 整合（Day 31～40）

* Day 31：使用 post block 實作 Jenkins 建置結果通知與清理流程
* Day 32：Jenkins 加入 Slack 通知機制
* Day 33：整合 Git commit log 與版本 changelog 產出
* Day 34：封裝 Jenkinsfile 為 Shared Library
* Day 35：使用 input block 加入人工審核節點
* Day 36：串接 GitHub PR comment 觸發 Jenkins job
* Day 37：整合 GitHub Actions 與 Jenkins 雙向協作
* Day 38：多服務建置（multi-repo）整合與串接
* Day 39：建立 matrix build（多環境交叉測試）
* Day 40：使用 Jenkins Credentials 管理憑證與部署帳號

---

## 🐳 Docker 進階應用與環境策略（Day 41～50）

* Day 41：多階段 Dockerfile 建構最佳化
* Day 42：瘦身映像，降低體積與快取設計
* Day 43：使用 Docker Compose 啟動多容器應用
* Day 44：設定 volume、network 與環境切換
* Day 45：設計 dev / staging / prod 多組 .env 結構
* Day 46：設定 Healthcheck 確保容器穩定性
* Day 47：容器啟動失敗排查與自動重啟策略
* Day 48：整合 NGINX / Traefik 實作反向代理
* Day 49：強化容器安全性（readonly / drop cap）
* Day 50：封裝可攜式 Docker 專案模板

---

## ☁️ 雲端部署與遠端操作（Day 51～60）

* Day 51：雲端三層架構概念（Web / App / DB）
* Day 52：申請 AWS EC2 並安裝 Docker + Jenkins
* Day 53：從 Jenkins 推送產物至遠端 EC2
* Day 54：SSH Key 配置與免密部署操作
* Day 55：使用 SCP / Rsync 自動化傳檔
* Day 56：在 EC2 上部署 docker-compose 專案
* Day 57：建置後健康檢查與存活驗證
* Day 58：Nginx + Let's Encrypt 架設 HTTPS
* Day 59：建立 Jenkins Slave 架構（遠端 Agent）
* Day 60：環境部署報告自動通知（Slack / Email）

---

## 🧪 測試與版本管理（Day 61～70）

* Day 61：撰寫單元測試並產出 JUnit 報告
* Day 62：整合 Jacoco 覆蓋率報告
* Day 63：SonarQube 靜態碼分析整合
* Day 64：Git Flow 分支策略與工作流程
* Day 65：使用 Conventional Commits 管理 commit message
* Day 66：自動產出 changelog 並發布 Release
* Day 67：語意化版本號（Semantic Versioning）管理
* Day 68：整合 webhook 通知測試驗收平台
* Day 69：設定 Pre-commit hook 與 Lint 驗證
* Day 70：測試錯誤即時通知並記錄 log 追蹤

---

## 🧱 測試與 CI/CD 實戰（Day 71～80）

* Day 71：撰寫整合測試並操作資料庫
* Day 72：使用 Testcontainers 動態啟動測試服務
* Day 73：整合 E2E 測試（Postman / Selenium）
* Day 74：整合 Swagger / Springdoc API 文件生成
* Day 75：Pipeline 整合全自動測試與報告
* Day 76：並行測試 Job 設計與排程
* Day 77：使用 DinD 建立隔離測試環境
* Day 78：異常紀錄擷取與報錯提示優化
* Day 79：整合報告輸出與通知整合
* Day 80：建立測試結束自動通知 hook

---

## ⚙️ IaC 與 Terraform 實作（Day 81～90）

* Day 81：認識 Infrastructure as Code 概念
* Day 82：學會撰寫 HCL 與 Terraform 結構
* Day 83：用 Terraform 建立 AWS EC2 範例
* Day 84：模組化部署與 variable / output 使用
* Day 85：Provisioner 安裝 nginx / Jenkins 自動化
* Day 86：設計 dev / staging / prod 多環境切換
* Day 87：使用 remote backend 儲存 state file
* Day 88：整合 Jenkins + Terraform 自動 apply
* Day 89：建立 IAM 使用者與存取控管
* Day 90：用 Terraform 一鍵佈署 Jenkins + Docker + app

---

## ☸️ Kubernetes 容器編排與部署實戰（Day 91～100）

* Day 91：Kubernetes 架構與核心物件（Pod / Node / Cluster）
* Day 92：安裝 Minikube 並建立本地測試環境
* Day 93：使用 kubectl 建立 Pod、Service、Deployment
* Day 94：撰寫 YAML 定義並上線應用
* Day 95：使用 ConfigMap 與 Secret 管理設定與憑證
* Day 96：Deployment 滾動更新與版本控制
* Day 97：Ingress Controller + NGINX 路由整合
* Day 98：多環境 namespace 設計與切換
* Day 99：安裝 Helm 並撰寫 chart 打包應用
* Day 100：整合 Jenkins 自動部署至 Kubernetes

---

## 🔐 DevSecOps 與容器安全控管（Day 101～110）

* Day 101：DevSecOps 概念與威脅來源介紹
* Day 102：Trivy 掃描映像檔漏洞整合 Jenkins
* Day 103：掃描第三方依賴套件（OWASP Dependency-Check）
* Day 104：SBOM 生成與元件清單管理
* Day 105：整合 OPA（Open Policy Agent）管理部署政策
* Day 106：使用 Kyverno 強化資源存取控管
* Day 107：設定 Seccomp / AppArmor 提升容器安全
* Day 108：Vault 管理敏感資料與環境變數
* Day 109：將安全掃描整合進 CI/CD pipeline
* Day 110：整合安全報告輸出與告警通知

---

## 📊 監控與日誌整合（Day 111～120）

* Day 111：Prometheus 架構與 Metrics 概念
* Day 112：部署 Node Exporter 與容器指標收集
* Day 113：整合 Grafana 並建立監控儀表板
* Day 114：設定 AlertManager 發送告警（Email / Slack）
* Day 115：整合 Jenkins 构建監控與失敗警示
* Day 116：理解日誌系統架構（Log / Trace / Audit）
* Day 117：部署 ELK Stack 並收斂應用日誌
* Day 118：使用 Filebeat / Fluentd 傳輸日誌
* Day 119：整合 Loki + Grafana 作為輕量日誌方案
* Day 120：建立 Dashboard 統一觀測狀態與日誌

---

## 🚀 GitOps 與自動部署策略（Day 121～130）

* Day 121：GitOps 是什麼？與 CI/CD 有何差別？
* Day 122：安裝 ArgoCD 並連接 Git Repository
* Day 123：撰寫 Helm Chart 並透過 GitOps 觸發部署
* Day 124：設定自動同步 / 手動審核機制
* Day 125：觀察 Git commit 自動 rollout 部署流程
* Day 126：整合 Jenkins 與 GitOps 雙向觸發策略
* Day 127：版本回滾與 rollback 策略設計
* Day 128：使用 Flux 實現另一種 GitOps 模式
* Day 129：GitOps 實作下的多環境部署實例
* Day 130：GitOps + DevSecOps 全自動安全交付案例

---

## 🎯 求職與作品整合（Day 131～140）

* Day 131：建立 DevOps 技術履歷（STAR 架構）
* Day 132：撰寫自我介紹與專案說明模板
* Day 133：將 Jenkins 專案與 GitHub 專案組合成作品集
* Day 134：將 K8s / Terraform 實作寫成部落格文章
* Day 135：錄製 Demo 短片與系統操作過程
* Day 136：建立 Notion / 部落格展示頁面
* Day 137：常見 DevOps 面試題彙整與自我回答演練
* Day 138：模擬技術白板問答與實作題流程
* Day 139：進行完整自我介紹 + 面試模擬排練
* Day 140：結訓 Demo + 正式開啟履歷投遞
