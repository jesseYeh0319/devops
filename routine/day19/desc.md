# ✅ DevOps120｜Day 19：整合 Git Push → 自動觸發 Jenkins Build（使用 Webhook）

## 🎯 今日目標

- 整合 GitHub 與 Jenkins
- 完成自動觸發建置流程
- 使用 ngrok 暫時公開 Jenkins 本機端口

---

## 📌 前置準備

### ✅ Jenkins Job 設定

到 Jenkins 的 Job 設定頁面：

- 勾選「Build Triggers（建置觸發器）」
  ```
  [✓] GitHub hook trigger for GITScm polling
  ```

---

## 🌐 使用 ngrok 暫時公開 Jenkins

安裝好 [ngrok](https://ngrok.com/)，啟動一條隧道：

```bash
ngrok http 8080
```

記下它產生的網址，例如：

```
https://abcd1234.ngrok-free.app
```

---

## 🔧 設定 GitHub Webhook

到你的 GitHub Repository：

- 「Settings」→「Webhooks」→「Add webhook」
- Payload URL 填入：

  ```
  https://abcd1234.ngrok-free.app/github-webhook/
  ```

- Content type：選 `application/json`
- Secret：可留空（如果 Jenkins 沒設定）
- 事件類型：選 `Just the push event`
- 儲存 Webhook

---

## ✅ 測試流程

1. Push 任意 commit 到 GitHub
2. 觀察 Jenkins 是否被觸發自動建置

---

## 🩹 錯誤排查

| 問題情境                            | 解法說明 |
|-------------------------------------|----------|
| Jenkins 沒反應                      | 確認是否勾選「GitHub hook trigger」與安裝 Plugin |
| GitHub webhook 顯示失敗             | 檢查 Payload URL 是否有 `/github-webhook/` 且 ngrok 是否連線中 |
| Jenkins 顯示 Invalid Hostname       | 可能 ngrok 斷線、免費帳號限時已過期，重啟後更新 Webhook URL |
| 沒安裝 GitHub Plugin 或 Integration | 進 Plugin 管理安裝即可 |

---

## 🧠 面試時怎麼講？

> 我整合 GitHub 與 Jenkins，使用 ngrok 代理本機 Jenkins，並透過 GitHub Webhook 建立 Git Push 即自動建置的流程，模擬真實開發時的 CI 起點。

---

## 🧪 延伸任務（選配）

- 改成用自己的 Git Server（如 Gitea、GitLab）
- 使用固定 ngrok domain（需付費）
- 整合 Slack webhook 通知建置狀況

