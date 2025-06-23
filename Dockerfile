# 1. GO + CGO destekli ortam
FROM golang:1.22 AS builder

WORKDIR /app

# PocketBase sürümünü indir (örnek: v0.20.1)
RUN git clone --branch v0.20.1 https://github.com/pocketbase/pocketbase.git .

# CGO: C kütüphaneleri aktif
ENV CGO_ENABLED=1
ENV CGO_CFLAGS="-O2"
ENV CGO_LDFLAGS="-s -w"

# SQLite için C kütüphanesi kur (linux-dev + sqlite)
RUN apt-get update && apt-get install -y \
    gcc musl-dev sqlite3 libsqlite3-dev

# PocketBase binary'sini CGO ile build et
RUN go build -tags "sqlite_omit_load_extension" -o /pb .

# 2. Uygulama container'ı (küçük, hızlı)
FROM alpine:3.18

WORKDIR /pb

# Sertifikalar (https istekleri için)
RUN apk add --no-cache ca-certificates bash sqlite

# CGO destekli PocketBase binary'sini ekle
COPY --from=builder /pb /pb/pocketbase

# Başlangıç betiği (PRAGMA + WAL ayarı yapılır)
COPY init-db.sh /pb/init-db.sh
RUN chmod +x /pb/init-db.sh

# SQLite veri klasörü
VOLUME /pb/pb_data

EXPOSE 8090

ENTRYPOINT ["/pb/init-db.sh"]