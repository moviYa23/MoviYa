FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY . .

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o logistics .

FROM alpine:3.18

WORKDIR /app

COPY --from=builder /app/logistics .

EXPOSE 8002

CMD ["./logistics"]
