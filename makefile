# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GORUN=$(GOCMD) run
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod
BINARY_NAME=investment-tracker
MAIN_PATH=cmd/server/main.go

# Docker parameters
DOCKER_COMPOSE=docker-compose
DOCKER=docker

# Environment
ENV ?= local

.PHONY: all build clean test run docker-build docker-run docker-stop help lint deps update-deps tag tag-dev

all: clean build

build:
	$(GOBUILD) -o $(BINARY_NAME) $(MAIN_PATH)

clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)

test:
	$(GOTEST) -v ./...

run:
	ENV=$(ENV) $(GORUN) $(MAIN_PATH)

# Docker commands
docker-build:
	$(DOCKER_COMPOSE) build

docker-up:
	$(DOCKER_COMPOSE) up -d

docker-down:
	$(DOCKER_COMPOSE) down

docker-logs:
	$(DOCKER_COMPOSE) logs -f

docker-ps:
	$(DOCKER_COMPOSE) ps

# Database commands
db-migrate:
	@echo "TODO: Add database migration command"

db-rollback:
	@echo "TODO: Add database rollback command"

# Development tools
lint:
	golangci-lint run

deps:
	$(GOMOD) download

update-deps:
	$(GOMOD) tidy

# Development environment
dev: docker-up
	@echo "Development environment is ready"

# Cleanup
clean-all: docker-down clean
	$(DOCKER) system prune -f
	rm -rf vendor/

# Создание production git-тега и отправка его в удалённый репозиторий.
# Использование: make tag TAG=v1.0.0
tag:
	@ if [ -z "$(TAG)" ]; then \
		echo "Ошибка: укажите переменную TAG, например: make tag TAG=v1.0.0"; \
		exit 1; \
	fi
	git tag -a $(TAG) -m "Release $(TAG)"
	git push origin $(TAG)

# Создание dev-тега и отправка его в удалённый репозиторий.
# Использование: make tag-dev TAG=dev-v1.0.0
tag-dev:
	@ if [ -z "$(TAG)" ]; then \
		echo "Ошибка: укажите переменную TAG, например: make tag-dev TAG=dev-v1.0.0"; \
		exit 1; \
	fi
	@ case "$(TAG)" in \
		dev-v*) echo "Создаем dev-тег $(TAG)";; \
		*) echo "Ошибка: TAG должен начинаться с 'dev-v'"; exit 1;; \
	esac
	git tag -a $(TAG) -m "Release (dev) $(TAG)"
	git push origin $(TAG)

# Help command
help:
	@echo "Available commands:"
	@echo "  make build          - Build the application"
	@echo "  make clean          - Clean build files"
	@echo "  make test           - Run tests"
	@echo "  make run            - Run application locally"
	@echo "  make docker-build   - Build Docker images"
	@echo "  make docker-up      - Start Docker containers"
	@echo "  make docker-down    - Stop Docker containers"
	@echo "  make docker-logs    - View Docker logs"
	@echo "  make docker-ps      - List running containers"
	@echo "  make lint           - Run linter"
	@echo "  make deps           - Download dependencies"
	@echo "  make update-deps    - Update dependencies"
	@echo "  make dev            - Start development environment"
	@echo "  make clean-all      - Deep clean of project"
	@echo "  make tag TAG=x.y.z  - Create a new production git tag and push it"
	@echo "  make tag-dev TAG=dev-vx.y.z  - Create a new dev git tag and push it"
	@echo "  make help           - Show this help message"

# Default goal
.DEFAULT_GOAL := help
