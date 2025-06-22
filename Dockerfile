FROM golang:1.21-alpine as builder

WORKDIR /app
COPY . .

RUN apk add --no-cache git ca-certificates && \
    go mod init postgresbase && \
    go get github.com/pocketbase/pocketbase@v0.20.1 && \
    go get github.com/spf13/cobra@v1.8.0 && \
    go build -tags 'pq' -o pocketbase

FROM alpine:latest
RUN apk add --no-cache ca-certificates

WORKDIR /pb
COPY --from=builder /app/pocketbase /usr/local/bin/pocketbase
COPY start.sh /pb/start.sh

RUN chmod +x /pb/start.sh
EXPOSE 8080

CMD ["/pb/start.sh"]
