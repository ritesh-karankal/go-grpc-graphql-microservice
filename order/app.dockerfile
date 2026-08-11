# Build stage
FROM golang:1.24-alpine AS builder

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY go.mod go.sum ./
COPY vendor ./vendor

COPY account ./account
COPY catalog ./catalog
COPY order ./order

RUN CGO_ENABLED=0 GOOS=linux go build \
    -mod=vendor \
    -o /app/app \
    ./order/cmd/order


# Runtime stage
FROM alpine:3.22

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /app/app .

EXPOSE 8080

CMD ["./app"]