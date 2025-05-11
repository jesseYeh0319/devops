✅ # devops 指令區
```
[DevOps120-技術轉職] Day 20：我已完成參數設定，請接著提供實作教學、Jenkinsfile 範例與 Anki 筆記（不要重複前面內容）

[DevOps120-技術轉職] Day XX：請開始今天的主題，並附上口語化的面試心得說法。

```

---

🧾 # prompt 

1.模板（未渲染純文字 + Emoji）
```
幫我產出一份 [DevOps120-技術轉職] Day XX 的內容：
請使用 Markdown 語法格式，但請將整份內容用「程式碼區塊（四個反引號）」包起來
我要的是 Markdown 原始碼，不是渲染後的樣子
這樣我才能按右上角複製 → 貼進 .md 或 Notion → 得到完整渲染效果
✅ 可以包含 Emoji、標題、代碼區塊等語法
✅ ChatGPT 不要預先渲染內容，請提供「可複製的未渲染 Markdown 原始碼」
```

---

🔗 # DevOps120 任務範例連結
```
Day 4：設定 crontab 排程執行 log 清理器
https://github.com/jesseYeh0319/devops/tree/main/routine/day4

Day 5：實作 log 清理結果通知（Line Notify 範例）
https://github.com/jesseYeh0319/devops/tree/main/routine/day5
```

---


```PROMT
先幫我統整我DAY1~DAY30 學了甚麼，
好讓我之後開新的對話，能夠讓你銜接，不會讓你給我重複的課程內容
```

# ✅ DevOps120 技術轉職計畫：Day 1～30 學習統整

---

## 🔧 Jenkins 核心操作與 CI/CD 建置流程（Day 1～20）

- ✅ Jenkins 安裝與 UI 操作
- ✅ 建立 Freestyle 與 Pipeline Job
- ✅ 使用 GitHub Webhook 自動觸發建置（含 ngrok 模擬）
- ✅ 參數化建置（Branch、環境選單）
- ✅ 使用 `Archive the artifacts` 保存建置產物
- ✅ 整合 Maven 打包 Spring Boot 專案
- ✅ Docker build / push / run 全流程實作
- ✅ 推送映像檔至 Docker Hub 並部署

---

## 🐳 Docker 自動化與映像管理（Day 21～25）

- ✅ 撰寫 log 清理 Shell 腳本
- ✅ 配合 crontab 自動執行容器 log 清理
- ✅ 使用 `docker-compose.yml` 管理 log cleaner 排程
- ✅ 撰寫 `.env` 並與 Docker Compose 整合參數
- ✅ 將 log-cleaner 清理結果推送 Slack 通知
- ✅ 改用 Volume 掛載 log 路徑，支援跨環境部署

---

## 📦 Docker 映像版本與部署策略（Day 26～30）

- ✅ Day 26：封裝 Jenkinsfile，完整整合 Maven + Docker + CI/CD 流程
- ✅ Day 27：改用 `./mvnw`，確保 Maven 版本一致並內建於專案中（含 `.mvn/jvm.config`）
- ✅ Day 28：使用 Jenkins 參數 `TAG`，實作動態 tag 推送映像（如 `dev-20240510`）
- ✅ Day 29：整合 Git commit hash，自動標記映像（如 `6e421af`），支援部署回溯
- ✅ Day 30：使用 `docker tag` 為同一映像標記多個語意 tag（如 `latest`、`dev`、build tag），並一次推送

---

## 💡 工具與概念累積

- Jenkins：參數化建置、Webhook、憑證管理、環境變數、post block
- Docker：映像建構、推送、tag 管理、Volume、Compose
- Git：rev-parse, commit hash、GitHub webhook
- Shell：crontab、log 清理、自動通知
- 組合概念：**一次 build → 多版本標記 → 多環境部署 → 全流程追蹤**

---

## 🧠 接下來建議方向（Day 31 之後）可避免重複：

- ❌ 不需再教：Docker Hub 推送、tag 基礎
- ✅ 可進階學：
  - Jenkins Shared Libraries（模組化流程）
  - Jenkins Credentials 與 Secrets 管理
  - Dockerfile 最佳化（多階段建構、多平台）
  - 映像掃描與安全性
  - 建置通知整合 Slack、Line Notify、GitHub PR status
  - 測試流程（JUnit + Test Report plugin）

---

# 🧠 DevOps140 Day 41～Day 45 統整心得（銜接新 Session 用）

---

## ✅ Day 41：多階段 Dockerfile 建構最佳化
- 學會 `FROM ... AS build` → `FROM ...` 多階段建構
- 目的：只留下可執行的 `.jar`，不把整個專案壓進映像
- 好處：映像更小、更乾淨、更安全

---

## ✅ Day 42：瘦身映像，降低體積與快取設計
- 加入 BuildKit 快取 `.m2` 目錄，加速 build
- 認識 `--mount=type=cache` 與 `DOCKER_BUILDKIT=1`
- 精簡 base image：從 `maven` → `temurin-jre`

---

## ✅ Day 43：使用 Docker Compose 啟動多容器應用
- 建立 `app + db` 多容器服務
- 學會 `depends_on` 控制啟動順序
- 使用 `.env` 控制 port、資料庫帳密等參數化配置

---

## ✅ Day 44：設定 volume、network 與環境切換
- Volume 綁定（預設 volume vs bind mount）
- Network 分組（如 backend），控制容器通訊範圍
- `.env` + `--env-file` 搭配使用初步實作

---

## ✅ Day 45：設計 dev / staging / prod 多組 .env 結構
- 將 `.env.dev`、`.env.staging`、`.env.prod` 分離
- Volume 命名統一、port 分組清楚
- 補上 Makefile 範本與部署手冊
- 建立切環境部署的可複製流程，利於 CI/CD 與團隊協作

---

> 🎯 你目前已具備：完整 Docker 專案骨架、環境分離設計、精簡映像打包、自動化部署流程雛型
> 🔜 可接續進入 GitHub Actions / Jenkins / 部署自動化等主題


---


# 🧠 DevOps140｜Day 46～Day 50 統整心得

## 🔒 Day 46：設定 Healthcheck 確保容器穩定性

- ✅ 使用 `healthcheck` 對 Spring Boot 容器設計 `/actuator/health` 探針
- ✅ 了解 Healthcheck 失敗不等於容器異常退出（不會觸發 restart policy）
- ⚠️ 踩坑：`/actuator/health` 回傳 404、應用尚未啟動時容器變成 running (unhealthy)
- 🔧 解法：搭配上層監控工具或 service orchestration 實作容器替換策略

---

## ⚠️ Day 47：容器啟動失敗排查與自動重啟策略

- ✅ 熟悉 `restart: no`、`on-failure[:N]`、`always` 策略用途與差異
- ✅ 用 `docker logs`、`docker inspect <id> --format='{{.State.ExitCode}}'` 排查啟動失敗原因
- 🔥 踩雷：Zombie container 導致 `docker stop` / `rm -f` 無效
- 🧠 知識補充：
  - AppArmor 殘留會導致 permission denied
  - `sudo aa-remove-unknown` 可清除未知 profile
  - 重啟主機為保險作法以清空 daemon namespace

---

## 🌐 Day 48：整合 NGINX / Traefik 實作反向代理

- ✅ 使用 NGINX `proxy_pass` 將 `/` 導向 Spring Boot 容器內部 port
- ⚠️ 踩坑：使用 bind mount 掛載 `default.conf`（來自 VirtualBox 共享目錄）導致容器無法停止
- ✅ 解法：改用 Dockerfile 中 `COPY` 打包設定檔 → 啟動穩定
- ✅ 瞭解 Traefik 能自動偵測 container 並註冊路由，未來可實作無設定化 Gateway
- 💡 體悟：反向代理不要依賴主機路徑 bind mount，否則極易卡死

---

## 🛡️ Day 49：強化容器安全性（readonly / drop cap）

- ✅ 使用 `read_only: true` 限制容器檔案系統寫入，強化最小操作範圍
- ✅ 使用 `cap_drop: ALL` 移除預設 Linux kernel 權限（避免提權攻擊）
- ✅ 有需要時再透過 `cap_add` 加回必要權限（如 CHOWN）
- 🧠 常見可移除權限：`SYS_ADMIN`、`NET_ADMIN`、`SYS_MODULE`
- 🗣️ 面試說法：部署容器時，我會使用唯讀與最低權限原則，防止應用程式異常行為影響主機

---

## 📦 Day 50：封裝可攜式 Docker 專案模板

- ✅ 建立標準結構：Dockerfile、docker-compose.yml、Makefile、.env、.env.example、README.md
- ✅ Makefile 封裝常用指令（up、down、build、logs）
- ✅ `.env.example` 協助團隊快速複製、並避免敏感資訊誤上傳
- ✅ 使用多階段 Dockerfile 打包 Spring Boot 可執行 JAR
- ✅ 專案具備可攜、可複製、可部署的特性，可作為履歷展示用模板

---

## 📌 學習總結

| 類別           | 關鍵詞與重點                     |
|----------------|----------------------------------|
| 容器穩定性     | `healthcheck`、unhealthy 排查     |
| 啟動失敗排查   | `docker logs`、Zombie、AppArmor   |
| 路由整合       | `proxy_pass`、COPY vs volume     |
| 安全性設計     | `read_only`、`cap_drop`、least privilege |
| 專案封裝       | `.env.example`、Makefile、模板化   |

---
