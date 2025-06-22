FROM golang:1.21 AS build

WORKDIR /app
COPY . .

RUN go mod download
RUN go build -o pocketbase ./pb/main.go

FROM debian:bookworm-slim

WORKDIR /app
COPY --from=build /app/pocketbase .

EXPOSE 8090

CMD ["./pocketbase", "serve", "--http=0.0.0.0:8090"]
