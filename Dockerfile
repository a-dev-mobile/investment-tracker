# Этап сборки
FROM golang:1.24rc3-alpine AS builder

WORKDIR /app

# Add build argument for environment
ARG ENV=local
ENV ENV=${ENV}

RUN apk add --no-cache git

# Копируем только файлы, необходимые для загрузки зависимостей
COPY go.mod go.sum ./
RUN go mod download

# Копируем исходный код
COPY . .

# Сборка приложения
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main cmd/server/main.go

# Финальный этап
FROM alpine:3.19

WORKDIR /app

# Установка необходимых пакетов
RUN apk --no-cache add ca-certificates tzdata

# Копируем бинарный файл из этапа сборки
COPY --from=builder /app/main .
COPY --from=builder /app/configs /app/configs

# Pass environment from build arg to runtime
ARG ENV=local
ENV ENV=${ENV}

RUN adduser -D appuser
USER appuser

# Объявляем порт
EXPOSE 8080

# Запускаем приложение
ENTRYPOINT ["./main"]