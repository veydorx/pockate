# 1. GO + CGO destekli ortam
FROM golang:1.22 AS builder

WORKDIR /app

# PocketBase indir
RUN git clone --branch v0.20.1 https://github.com/pocketbase/pocketbase.git .

# CGO: C desteği açık
ENV CGO_ENABLED=1
ENV CGO_CFLAGS="-O2"
ENV CGO_LDFLAGS="-s -w"

# SQLite C kütüphaneleri
RUN apt-get update && apt-get install -y \
    gcc musl-dev sqlite3 libsqlite3-dev

# Binary üret
RUN go build -tags "sqlite_omit_load_extension" -o /pb .

# 2. Çalıştırılacak image
FROM alpine:3.18

WORKDIR /pb

RUN apk add --no-cache ca-certificates bash sqlite

COPY --from=builder /pb /pb/pocketbase
COPY init-db.sh /pb/init-db.sh
RUN chmod +x /pb/init-db.sh

EXPOSE 3000

ENTRYPOINT ["/pb/init-db.sh"]
