# ☁️ DevOps140｜Day 51：雲端三層架構概念（Web / App / DB）

---

## 🎯 今日目標

- 理解傳統與雲端環境中的三層架構（Web / App / DB）
- 理清每層的責任、部署方式、維運關鍵
- 為之後的 **Kubernetes 分層部署與服務暴露** 奠定概念基礎

---

## 🧱 三層架構介紹

三層架構（Three-Tier Architecture）是一種**模組化設計方式**，將應用程式拆成三個邏輯層，以利分離責任、彈性擴充與集中維運：

| 層級 | 角色說明 | 常見技術 |
|------|----------|----------|
| Web Layer（表示層） | 處理 UI / 請求接收與轉發 | NGINX、Apache、ELB、CloudFront |
| App Layer（邏輯層） | 執行應用程式邏輯與服務 | Spring Boot、Node.js、.NET Core、Flask |
| DB Layer（資料層） | 管理與儲存資料 | MySQL、PostgreSQL、MongoDB、Redis |

---

### 📌 層與層之間的連線方式

- Web → App：常透過 Reverse Proxy 或 Load Balancer 將流量導向 App
- App → DB：透過內部私有網路（如 VPC）連線，避免外部存取風險
- 每層通常部署於不同 VM / Container / Pod，並配置專屬安全群組

---

## ☁️ 雲端部署案例（以 AWS 為例）

```text
[Client Browser]
       │
       ▼
[Amazon CloudFront] → [Application Load Balancer (ALB)]
       │
       ▼
 [App EC2 / ECS / EKS] ←→ [RDS / ElastiCache]
```

- ✅ Web 層：CloudFront/CDN + ALB
- ✅ App 層：EC2、ECS、或 EKS（Kubernetes）
- ✅ DB 層：RDS（關聯式）或 DynamoDB（NoSQL）

---

## 🔍 維運觀點：DevOps 需掌握的三層責任

| 責任區 | DevOps 實務處理             |
|--------|------------------------------|
| 部署方式 | 使用 IaaS / Container / Helm |
| 健康監控 | 建立每層的 Probe 與 Logging |
| 效能調校 | 實施 Auto Scaling、Connection Pool、Cache |
| 安全控制 | 網段隔離、防火牆規則、安全群組、IAM 權限 |

---

## 💬 面試口語說法

> 在實際專案中，我們通常會採用三層架構來提升可維護性與安全性。我負責的 DevOps 作業包含：
> - **Web 層**：設計 NGINX 與 ALB 的路由與反向代理規則
> - **App 層**：使用容器部署 Spring Boot 應用，並監控其健康狀態
> - **DB 層**：協助開發團隊調整連線池與隔離權限，並透過 VPC 隔離外部存取
> 
> 我們會根據不同層級設定不同的 CI/CD 流程與監控策略，例如 App 層會部署 Prometheus 與 Grafana，DB 層會針對效能瓶頸進行慢查詢分析。

---

## 🧠 小結

- 三層架構是微服務與 Kubernetes 架構的基礎，能幫助你了解分層部署邏輯
- 每層具備不同的部署模式與安全考量，DevOps 要能設計並自動化這三層的流程

