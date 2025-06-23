FROM golang:1.22 AS builder
WORKDIR /app
RUN git clone --branch v0.20.1 https://github.com/pocketbase/pocketbase.git .
ENV CGO_ENABLED=1 CGO_CFLAGS="-O2" CGO_LDFLAGS="-s -w"
RUN apt-get update && apt-get install -y gcc musl-dev sqlite3 libsqlite3-dev
RUN go build -tags "sqlite_omit_load_extension" -o /pb/pocketbase main.go

FROM alpine:3.18
WORKDIR /pb
RUN apk add --no-cache ca-certificates bash sqlite
COPY --from=builder /pb/pocketbase /pb/pocketbase
COPY init-db.sh /pb/init-db.sh
RUN chmod +x /pb/pocketbase /pb/init-db.sh
RUN mkdir -p /pb/pb_data && chmod -R 777 /pb/pb_data

EXPOSE 3000
ENTRYPOINT ["/pb/init-db.sh"]
