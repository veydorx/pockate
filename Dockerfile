# Build aşaması
FROM golang:1.23-alpine AS builder

# Çalışma dizini
WORKDIR /src

# Gerekli araçları yükle
RUN apk add --no-cache git gcc musl-dev

# go.mod ve go.sum dosyalarını kopyala
COPY go.mod go.sum ./
RUN go mod tidy

# Tüm kaynak kodunu kopyala
COPY . .

# Performanslı build için CGO
ENV CGO_ENABLED=1
RUN go build -o /pocketbase -ldflags "-s -w" ./main.go

# Final aşama (küçük imaj)
FROM alpine:latest

# Çalışma dizini
WORKDIR /app

# Gerekli sistem kütüphaneleri
RUN apk add --no-cache ca-certificates tzdata

# Binary’yi kopyala
COPY --from=builder /pocketbase /app/pocketbase

# (İsteğe bağlı) pb_data klasörünü oluştur
RUN mkdir -p /app/pb_data

# Portu aç
EXPOSE 8090

# Uygulamanı başlat
CMD ["/app/pocketbase"]
