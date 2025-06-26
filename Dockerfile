# Build stage
FROM golang:1.23-alpine AS builder

# Çalışma dizini
WORKDIR /src

# PostgreSQL client ve build araçları
RUN apk add --no-cache git gcc musl-dev postgresql-client

# Go modülleri için go.mod ve go.sum dosyalarını kopyala
COPY go.mod go.sum ./
RUN go mod tidy

# Tüm kaynak kodunu kopyala
COPY . .

# CGO ile yüksek performanslı binary derle
ENV CGO_ENABLED=1
RUN go build -o /pocketbase -ldflags "-s -w" ./main.go

# Final stage
FROM alpine:latest

# Çalışma dizini
WORKDIR /app

# PostgreSQL client ve gerekli bağımlılıkları yükle
RUN apk add --no-cache ca-certificates tzdata postgresql-client

# Binary'yi kopyala
COPY --from=builder /pocketbase /app/pocketbase

# Portu expose et
EXPOSE 8090

# PocketBase'i başlat
CMD ["/app/pocketbase", "serve", "--http=0.0.0.0:8090"]
