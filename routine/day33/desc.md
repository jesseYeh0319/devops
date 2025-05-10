# 📚 [DevOps140-技術轉職計畫]  
## Day 33：整合 Git commit log 與版本 changelog 產出 🧾🔖

---

## 🎯 今日目標

學會透過 Git commit 訊息自動產出版本 changelog，並整合至 Jenkins pipeline，達成版本可追蹤、自動歸檔。

- 使用 `git log` 擷取提交記錄
- 產出標準格式的 `CHANGELOG.md`
- Jenkins 歸檔 changelog 為建置產物
- 搭配 git tag 標記版本

---

## 🧠 changelog 是什麼？有什麼用？

| 場景 | 用途 |
|------|------|
| 發佈版本 | 告訴使用者這個版本更新了什麼 |
| 團隊協作 | 協助 QA、PM 快速了解改動內容 |
| 回溯問題 | 可以對應到特定 commit 與版本 tag |
| 開源專案 | 結合 GitHub Release 對外說明版本差異 |

---

## 🔧 Git log → CHANGELOG.md 範例

```bash
git log -n 10 --pretty=format:"* %s (%an) [%h]" > CHANGELOG.md
```

產出內容範例：

```
* feat: 新增使用者登入功能 (jesse) [abc1234]
* fix: 修正密碼驗證錯誤 (weiyang) [def5678]
```

---

## 🛠️ Jenkinsfile 整合 changelog 自動產出

```groovy
stage('產出 changelog') {
  steps {
    echo '產出 changelog...'
    sh 'git log -n 10 --pretty=format:"* %s (%an) [%h]" > CHANGELOG.md'
    archiveArtifacts artifacts: 'CHANGELOG.md', fingerprint: true
  }
}
```

---

## 🛠️ Jenkinsfile 搭配 Git tag 自動標記版本

```groovy
stage('標記版本') {
  steps {
    echo '標記版本...'
    script {
      def tag = "v1.0-${env.BUILD_NUMBER}"
      withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
        sh 'git config user.email "ci@example.com"'
        sh 'git config user.name "jenkins-bot"'
        sh 'git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@github.com/jesseYeh0319/demo.git'
        sh "git tag ${tag}"
        sh "git push origin ${tag}"
      }
    }
  }
}
```

---

## ✅ 任務完成標準

- [ ] `CHANGELOG.md` 檔案成功產出且可下載
- [ ] Jenkins 每次 build 都會更新 changelog
- [ ] GitHub tag 成功推送並可於 repo 中查看
- [ ] Jenkinsfile 內含完整 changelog + tag 自動化邏輯

---

## 🗣 面試口語化說法

>「我在 Jenkins pipeline 中加入 git log 產生 changelog，每次建置都會保存為 artifacts，同時自動打上對應的版本 tag 並推送至 GitHub，確保每個版本可追蹤且對應到明確的 commit。這對於回溯問題、對外發佈說明、與 QA 溝通都非常有幫助。」

---

