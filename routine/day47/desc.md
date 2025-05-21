# 🚨 DevOps140 - Day 47：容器啟動失敗排查與自動重啟策略

---

## 🎯 今日目標

- 系統性排查容器啟動失敗的原因
- 實作 `restart` 自動重啟策略（如 `on-failure`）
- 搭配 `Healthcheck` 與 log 分析強化穩定性

---

## 📚 Restart Policy 比較表

| 策略            | 說明                                       |
|------------------|--------------------------------------------|
| `no`             | 預設值，不會自動重啟                      |
| `always`         | 無論退出狀態如何，都會自動重啟            |
| `on-failure[:N]` | 當容器異常退出（exit code ≠ 0）才重啟     |
| `unless-stopped` | 永遠重啟，除非手動停止                    |

---

## 🛠️ 實作範例：Docker Compose 設定 restart 策略

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    restart: on-failure:3
    ports:
      - "${APP_PORT}:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=dev
    healthcheck:
      test: ["CMD", "curl", "--fail", "http://localhost:8080/actuator/health"]
      interval: 10s
      timeout: 3s
      retries: 3
      start_period: 20s
```

---

## 🔍 排查容器啟動失敗的步驟

### ✅ Step 1：查看容器狀態

```bash
docker ps -a
```

### ✅ Step 2：查看容器 log

```bash
docker logs <container_id>
```

常見錯誤：
- Port already in use
- 無法連接資料庫
- Java 啟動錯誤 / class not found

### ✅ Step 3：檢查容器退出碼

```bash
docker inspect <container_id> --format='{{.State.ExitCode}}'
```

| Exit Code | 意義 |
|-----------|------|
| 0         | 正常結束 |
| 非 0      | 異常結束，會觸發 on-failure 重啟 |

---

## 🧪 測試：模擬容器啟動錯誤

在 Dockerfile 中修改 CMD：

```dockerfile
CMD ["sh", "-c", "echo 啟動錯誤中...; exit 1"]
```

啟動後觀察：

```bash
docker ps -a
```

容器會自動重啟最多三次（若設定 `on-failure:3`），再進入 stopped 狀態。

---

## ⚠️ 注意事項

- `restart: always` 若與 `healthcheck` 結合失當，會導致 container 無限重啟
- `on-failure` 不會重啟因 healthcheck fail 而 unhealthy 的容器（那是由 orchestrator 判斷）
- 強烈建議 Healthcheck + on-failure 搭配使用

---

## 🗣️ 面試口語化說法建議

> 我在實作 Docker 化部署時，除了加入 Healthcheck 外，還會根據服務重要性設計 `restart policy`。  
像是非關鍵服務我會用 `on-failure:3`，讓它自動重啟最多三次就停止，避免 zombie container 無限循環。  
關鍵服務則會搭配監控與外部重啟機制。透過 `docker logs` 與 `exit code` 可以精準排查問題來源，不盲目重啟。

---

## 🧠 ANKI 筆記（面試重點）

### Q: Docker 中有哪些 restart 策略？
A: `no`（預設）、`always`、`on-failure[:N]`、`unless-stopped`

---

### Q: `on-failure:3` 是什麼意思？
A: 當容器異常結束（exit code ≠ 0）時，自動重啟最多 3 次

---

### Q: 如何查看容器啟動失敗原因？
A: 使用 `docker logs` 查看日誌，並搭配 `docker inspect <id> --format='{{.State.ExitCode}}'` 檢查退出碼

---

### Q: `restart: always` 有什麼潛在風險？
A: 容器若啟動異常仍會持續重啟，導致 zombie container 無限循環，需小心使用

---

### Q: Healthcheck fail 會觸發 restart policy 嗎？
A: 不會，Healthcheck fail 不等於 exit。若需重啟，需外部工具或自行設計。

---
``

