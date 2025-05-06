```markdown
# DevOps120｜Day 16：Jenkins 儲存建置產出物（Artifact）

## 🎯 今日目標

- 使用 Jenkins 的「Archive the artifacts」功能
- 將 Maven 打包的 JAR 檔正式存為可下載產出物
- 建立可追蹤的建置歷史，支援後續部署或交付

---

## 🛠️ 步驟 1：正常建置出產物

先確保 Jenkins job 的 Shell 步驟會成功產出 `.jar` 檔案，例如：

```bash
mvn clean package
ls -lh target/*.jar
```

---

## 🧩 步驟 2：設定儲存 Artifact

Jenkins Job 設定 →「Post-build Actions」→「Archive the artifacts」

欄位填入：

```
target/*.jar
```

這表示只保存目標資料夾內的所有 jar 檔

---

## 🗃️ 成效示意

- 每次建置後 Jenkins UI 會出現 `.jar` 檔連結
- 即使工作目錄被清除，仍可從「建置記錄」中下載
- 支援串接部署、測試、自動上傳

---

## ✅ 技術總結

| 項目                  | 沒設定 Artifact            | 有設定 Artifact ✅          |
|-----------------------|----------------------------|-----------------------------|
| 是否有產出 .jar       | ✅ 有                       | ✅ 有                        |
| 使用者可否下載        | ❌ 否（除非手動進容器）     | ✅ Jenkins UI 可下載         |
| Jenkins 是否會保留     | ❌ 無保障，workspace 會清   | ✅ 永久存在於建置記錄中       |
| 是否能串接後續流程    | ❌ 難                       | ✅ 可串接部署、測試、自動化   |

---

## 💬 面試怎麼說？

> 我會使用 Jenkins 的「Archive the artifacts」功能來保存建置產出物，讓每次建置都有可下載的 JAR 檔，支援後續部署與問題追蹤，不怕中途工作目錄被清除。
```

