# Build stage
FROM golang:1.23-alpine AS builder

# Çalışma dizini
WORKDIR /src

# PostgreSQL client ve build araçları
RUN apk add --no-cache git gcc musl-dev

# Go modülleri için go.mod ve go.sum dosyalarını kopyala
COPY go.mod go.sum ./

# Modülleri indir
RUN go mod download

# Tüm kaynak kodunu kopyala
COPY . .

# Binary derle
ENV CGO_ENABLED=0
ENV GOOS=linux
RUN go build -a -installsuffix cgo -o /pocketbase -ldflags "-s -w" ./main.go

# Final stage
FROM alpine:latest

# Çalışma dizini
WORKDIR /app

# Gerekli bağımlılıkları yükle
RUN apk add --no-cache ca-certificates tzdata

# Binary'yi kopyala
COPY --from=builder /pocketbase /app/pocketbase

# Portu expose et
EXPOSE 8090

# PocketBase'i başlat
CMD ["/app/pocketbase", "serve", "--http=0.0.0.0:8090"]
