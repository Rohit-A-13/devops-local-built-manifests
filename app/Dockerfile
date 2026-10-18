# Stage 1: Build
FROM golang:1.22-alpine AS builder
WORKDIR /src
COPY go.mod ./
COPY main.go ./
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /app

# Stage 2: Runtime
FROM alpine:3.20
RUN adduser -D -u 10001 appuser
COPY --from=builder /app /app
USER appuser
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=3s CMD wget -qO- http://localhost:8080/healthz || exit 1
CMD ["/app"]
