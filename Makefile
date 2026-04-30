.PHONY: help build up down logs shell clean backend-only dev-backend dev-frontend install db-connect

help:
	@echo "MongoDB Atlas Bookings - Development Commands"
	@echo ""
	@echo "Available commands:"
	@echo "  make build          - Build Docker containers"
	@echo "  make up             - Start all services"
	@echo "  make down           - Stop all services"
	@echo "  make logs           - View all container logs"
	@echo "  make logs-backend   - View backend logs"
	@echo "  make logs-frontend  - View frontend logs"
	@echo "  make shell          - Open a shell in the backend container"
	@echo "  make db-connect     - Connect to MongoDB using MONGODB_CONNECTION_STRING"
	@echo "  make backend-only   - Start only backend"
	@echo "  make clean          - Clean up containers and volumes"
	@echo ""
	@echo "Development (without Docker):"
	@echo "  make dev-backend    - Run backend locally"
	@echo "  make dev-frontend   - Run frontend locally"
	@echo "  make install        - Install all dependencies"

build:
	docker-compose build

up:
	docker-compose up -d
	@echo ""
	@echo "✅ Services started!"
	@echo "   - Frontend:    http://localhost:3000"
	@echo "   - Backend API: http://localhost:8000/docs"
	@echo "   - Database:    Set MONGODB_CONNECTION_STRING for Atlas connectivity"
	@echo ""

down:
	docker-compose down

logs:
	docker-compose logs -f

logs-backend:
	docker-compose logs -f backend

logs-frontend:
	docker-compose logs -f frontend

shell:
	docker-compose exec backend /bin/bash

db-connect:
	@if [[ -z "$$MONGODB_CONNECTION_STRING" ]]; then \
		echo "MONGODB_CONNECTION_STRING is not set"; \
		exit 1; \
	fi
	mongosh "$$MONGODB_CONNECTION_STRING"

backend-only:
	docker-compose up -d backend
	@echo "✅ Backend started"
	@echo "   - Backend API: http://localhost:8000/docs"

clean:
	docker-compose down -v
	@echo "✅ Containers removed"

# Development commands (run locally without Docker)
dev-backend:
	cd src/api && uvicorn main:app --reload --host 0.0.0.0 --port 8000

dev-frontend:
	cd src/frontend && npm start

install:
	pip install -r requirements.txt
	cd src/frontend && npm install
	@echo "✅ All dependencies installed"
