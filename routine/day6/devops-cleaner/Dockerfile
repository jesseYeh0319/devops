FROM alpine:3.18

RUN apk add --no-cache bash curl grep coreutils

COPY cleanup_logs.sh /app/cleanup_logs.sh
COPY .env /app/.env
WORKDIR /app

ENTRYPOINT ["./cleanup_logs.sh"]

