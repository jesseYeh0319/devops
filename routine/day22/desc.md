DevOps120 - 技術轉職計畫：Day 22

🎯 主題：Docker Compose 與 Jenkins 整合應用

📌 今日目標：
允許一次性啟動多個容器（app + db）
使用 docker-compose.yml 管理多服務開發環境
整合 Jenkins + Docker Compose，實作一鍵建置與測試
學會如何透過 log、port、網路互通確認服務正常

🛠️ 任務步驟

步驟一：撰寫 docker-compose.yml（含 app + PostgreSQL）

version: '3.8'

services:
app:
build:
context: .
dockerfile: Dockerfile
ports:
- "8080:8080"
environment:
- SPRING_PROFILES_ACTIVE=dev

db:
image: postgres:14
restart: always
environment:
POSTGRES_DB: mydb
POSTGRES_USER: user
POSTGRES_PASSWORD: password
ports:
- "5432:5432"
volumes:
- pg_data:/var/lib/postgresql/data

volumes:
pg_data:

步驟二：透過 docker-compose 指令操作

啟動全部服務：
docker-compose up -d

查看狀態：
docker-compose ps

查看 app log：
docker-compose logs -f app

停止並清除：
docker-compose down

重建並強制不快取（解決 jar 未更新問題）：
docker-compose build --no-cache

📦 補充說明：Docker Build Cache 問題

Docker build 過程中會針對 COPY、RUN 等指令使用快取
改動少量檔案（例如 banner.txt）時，可能不會觸發重新建構
建議開發時使用 --no-cache 或精確切割 COPY 指令來強制重建

🧠 實戰提醒：
docker-compose.yml 中的每個 service 會在同一虛擬網路中啟動
app 可以透過 hostname "db" 直接連線至 PostgreSQL
多個 app 或 db 可以用不同 service 名稱啟動
若服務未啟動成功，請使用 docker-compose logs 或 docker-compose ps -a 觀察狀態

🎁 延伸挑戰（選做）：
將 app + db 擴充為三服務架構（app + db + redis）
嘗試使用 .env 管理 port、密碼、版本資訊
將 docker-compose.yml 接入 Jenkins job，實作 CI 環境快速部署

📚 小結：
docker-compose 是 DevOps 初期開發環境管理的強力工具
結合 Jenkins 後可快速模擬部署環境與整合測試
若搭配 volume 和 profile，亦能支援跨環境配置（dev / test / prod）
