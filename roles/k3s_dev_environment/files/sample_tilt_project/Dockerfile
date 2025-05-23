# roles/k3s_dev_environment/files/sample_tilt_project/Dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
# For go.mod/go.sum based projects:
# COPY go.mod go.sum ./
# RUN go mod download
# COPY . .
ENV CGO_ENABLED=0
RUN go build -ldflags="-s -w" -o /app/hello-world main.go

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/hello-world .
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
EXPOSE 8080
CMD ["./hello-world"]