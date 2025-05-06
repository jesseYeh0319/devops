# DevOps120 技術轉職｜Day 17：推送映像檔至 Docker Hub

## 🟡 學習目標

- 將 Jenkins 製作出的映像檔，自動推送到 Docker Hub

---

## 🧪 實作任務

### 步驟 1：建立 Docker Hub 帳號

註冊：https://hub.docker.com/

建立 Repository，如：
```
帳號：yehweiyang
Repo：petclinic
```

---

### 步驟 2：Jenkins 中設定 Credentials

1. 前往「Jenkins > 管理 Jenkins > Credentials > System > Global」新增一組：
   - 種類：Username with password
   - ID：docker-hub（可自訂）
   - Username：Docker Hub 帳號
   - Password：Docker Hub 密碼或 Token

---

### 步驟 3：Jenkins Job 加入 Credentials Binding

1. 在 Job 中選擇：
   - `Use secret text(s) or file(s)`
   - Bindings > `Username and password (separated)`
     - Username Variable：`DOCKER_USERNAME`
     - Password Variable：`DOCKER_PASSWORD`
     - Credential：選剛才新增的 `docker-hub`

---

### 步驟 4：Shell Script 推送 Image

在「建置」步驟中輸入以下指令：

```bash
git clean -fdx
git reset --hard

# 編譯 Java 專案
mvn clean package

# 查看產出物
ls -lh target/*.jar

# 建立 Docker 映像檔
docker build --no-cache -t yehweiyang/petclinic:latest .

# 登入 Docker Hub 並推送映像檔
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push $DOCKER_USERNAME/petclinic
```

---

## 🪤 實際遇到的坑：Jenkins 抓錯 Git Repository URL
問題描述：
在 Jenkins 設定中曾修改過 Git Repository 的 URL，但系統仍然持續使用舊的 URL。

原因分析：
Jenkins 的 workspace 仍保留著 .git/config 的舊遠端設定。

解法：
勾選 Job 的 Build Environment → Delete workspace before build starts
可保證每次建置使用乾淨的專案環境。

---
## 🧠 補充說明

- `docker build -t yourname/image` 中的 `yourname` 必須為 Docker Hub 帳號，否則會無權限推送。
- `--password-stdin` 是非互動登入的安全方式，適合 CI。
- 使用 Credentials Binding Plugin 可避免將帳號密碼寫死在指令中。

---

## ✅ 驗收標準

- [ ] Jenkins 可自動登入 Docker Hub 並推送映像檔
- [ ] 成功於 Docker Hub 上看到新版本映像檔

---


