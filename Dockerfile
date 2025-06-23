FROM golang:1.21 AS builder

WORKDIR /app
COPY . .

RUN go mod tidy
RUN go build -tags "sqlite_omit_load_extension" -o /pb/pocketbase

FROM alpine:latest

WORKDIR /pb

RUN apk add --no-cache sqlite

COPY --from=builder /pb/pocketbase ./pocketbase
COPY init-db.sh ./init-db.sh

RUN chmod +x ./init-db.sh
RUN mkdir -p ./pb_data

EXPOSE 3000

CMD ["./init-db.sh"]