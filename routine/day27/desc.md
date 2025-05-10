# [DevOps120-技術轉職] Day 27：使用 Maven Wrapper（mvnw）整合 Jenkins Pipeline 🔄☕️

## 🎯 今日目標

讓 Jenkins Pipeline 完全使用 `mvnw`（Maven Wrapper）進行建置流程，確保 Maven 版本一致、可攜性高、與 CI/CD 環境解耦。

---

## 🧠 Maven Wrapper 是什麼？

Maven Wrapper 是一種專案內建的 Maven 啟動工具，可以自動下載、快取並執行指定版本的 Maven，不需主機預裝 Maven。

### ✅ 它包含的檔案（需版本控管）：
- `mvnw` / `mvnw.cmd`：跨平台執行入口
- `.mvn/wrapper/maven-wrapper.jar`：執行邏輯
- `.mvn/wrapper/maven-wrapper.properties`：定義 Maven 版本
- `.mvn/jvm.config`（可選）：設定 JVM 啟動參數

---

## 🛠️ 如何產生 `mvnw`

```bash
mvn -N io.takari:maven:wrapper
```

這只需執行一次，之後將產生的檔案版本控管進 Git，即可跨 Jenkins / 開發者機使用。

---

## 📁 `.mvn/wrapper/maven-wrapper.properties` 範例

```properties
distributionUrl=https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.3/apache-maven-3.9.3-bin.zip
```

表示 Maven Wrapper 會自動下載 3.9.3 版本。

---

## 🧠 解耦的真正意義

> ❗ 不是每台主機都執行一次 wrapper，而是 **一次建立、版本控管、跟著專案跑。**

Jenkins、Docker 容器、任何 Agent 只要有 Java，就能跑 `./mvnw` 建置，**不依賴主機有安裝 Maven。**

---

## ⚙️ `.mvn/jvm.config` 用法

這個檔案可指定 JVM 啟動參數，會與 `./mvnw` 搭配一起執行，例如：

```
-Xms512m
-Xmx2048m
-Dfile.encoding=UTF-8
```

這可避免記憶體爆炸、中文亂碼等 JVM 問題。

---

## ✅ Jenkinsfile 使用 mvnw 範例

```groovy
pipeline {
  agent any

  environment {
    IMAGE_NAME = 'yehweiyang/demo:latest'
    DOCKERHUB_CREDENTIALS = 'docker-hub'
  }

  stages {
    stage('確認 Maven Wrapper') {
      steps {
        sh 'ls -l ./mvnw'
        sh './mvnw -version'
      }
    }

    stage('打包專案') {
      steps {
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('建構並推送 Docker 映像檔') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
        withCredentials([
          usernamePassword(credentialsId: "$DOCKERHUB_CREDENTIALS", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
        ]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
        }
        sh 'docker push $IMAGE_NAME'
      }
    }
  }

  post {
    success {
      echo '✅ 使用 mvnw 建構與推送完成'
    }
    failure {
      echo '❌ 建構失敗，請檢查錯誤日誌'
    }
  }
}
```

---

## 🔚 小結

- `mvnw` 是專案內建 Maven，版本可控、不依賴 Jenkins 主機安裝
- `.mvn/jvm.config` 可統一 JVM 參數，避免記憶體與編碼問題
- 一次設定，全專案、全 Jenkins Agent、全開發者一致執行

📌 Day 27 的目的是：**不是學一個指令，而是建立穩定建構環境的思維與實踐**

---

