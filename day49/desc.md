# 🛡️ [DevOps140] Day 49：強化容器安全性（readonly / drop cap）

## ✅ 今日目標

- 了解預設 Docker 容器的權限模型
- 學會透過 `read_only: true` 讓容器變成唯讀模式
- 使用 `cap_drop` 移除 Linux Capability 權限（如 NET_ADMIN、SYS_ADMIN）
- 實作「最低權限原則」的 container 配置
- 明白哪些權限最常被濫用、可移除以強化防禦

---

## 🔍 為什麼需要容器層級安全加固？

即使你不開 SSH、只跑 Web App，**攻擊者仍可能利用容器內漏洞取得外部控制權限**：

- 利用容器內部寫入檔案或 log injection 嘗試突破主機
- 呼叫具有特權的 system call（如 NET_ADMIN 建立 VPN 隧道）
- 經由 mount 點嘗試存取宿主機敏感目錄

→ 為了防止容器誤用或被駭後濫用資源，**安全性配置是 DevOps 的防線之一**

---

## 🔧 安全加固技術 1：唯讀容器 `read_only: true`

在 `docker-compose.yml` 中加入：

```yaml
services:
  app:
    image: demo-app
    read_only: true
    volumes:
      - /tmp   # ⚠️ 唯讀模式下容器需指定「可寫入」掛載點
```

### ✅ 效果：
- `/` 根目錄變為唯讀，無法寫入任何檔案
- 若應用需寫 log，請配合 volumes 指定 /tmp 或 /var/log

---

## 🔧 安全加固技術 2：移除 Linux Capability 權限 `cap_drop`

Linux kernel 預設給 Docker container 很多權限，例如：

- `NET_ADMIN` → 建立/管理網路介面
- `SYS_ADMIN` → 超廣泛系統操作（幾乎等於 root）
- `CHOWN`、`SETUID` → 改變檔案擁有者

在 compose 中可以這樣限制：

```yaml
services:
  app:
    image: demo-app
    cap_drop:
      - ALL
```

或選擇性保留：

```yaml
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
```

---

## 🧠 常見可放心移除的 Capability 清單

| 權限        | 說明                     | 建議           |
|-------------|--------------------------|----------------|
| `SYS_ADMIN` | 超級權限，避免一切風險     | 🔥 一定移除     |
| `NET_ADMIN` | 建 VPN / 改路由            | ✅ 可移除       |
| `MKNOD`     | 建立特殊裝置檔              | ✅ 可移除       |
| `SYS_MODULE`| 載入 kernel 模組           | ✅ 不該保留     |

---

## 🎯 實作練習：加固 Spring Boot 容器

```yaml
services:
  app:
    image: demo-app
    read_only: true
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
    volumes:
      - /tmp    # 指定可以寫入的位置
```

---

## 🗣️ 面試時怎麼說這一題？

> 我在部署容器時有實作過最低權限原則。除了設定非 root user，我也會使用 `read_only: true` 讓容器無法隨意寫入檔案，並使用 `cap_drop: ALL` 移除預設 Linux 權限。只有需要像 CHOWN 的權限才會加回。這樣即使應用被攻擊，也能降低橫向擴張風險。

---

## ✅ 結語

你已經學會：
- 讓容器 root filesystem 變成唯讀
- 移除過度授權的 kernel capability
- 實踐 DevOps 的安全責任：部署不等於暴露

🔜 下一站將學習：容器資源限制（CPU、Memory）與 runtime 安全分析！

