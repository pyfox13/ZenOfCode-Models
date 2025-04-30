# ==========================================
# 🧱 Makefile for ZenOfCode-Models
# Manages local PostgreSQL & Alembic Migrations
# ==========================================

include .env
export
SHELL := /bin/bash

.PHONY: help db-up db-down db-restart db-wait logs run-migration db-reset new-migration

help:
	@echo "Available commands:"
	@echo "  db-up         - Start PostgreSQL container"
	@echo "  db-down       - Stop and remove the container"
	@echo "  db-restart    - Restart PostgreSQL container"
	@echo "  db-wait       - Wait until DB is ready to accept connections"
	@echo "  logs          - Tail logs from the DB container"

db-up:
	@echo "🚀 Starting PostgreSQL container..."
	@docker compose up -d
	@$(MAKE) db-wait
	@echo "✅ PostgreSQL started!"

db-down:
	@echo "🛑 Stopping PostgreSQL container..."
	@docker compose down

db-restart: db-down db-up

db-wait:
	@echo "⏳ Waiting for PostgreSQL to become available..."
	@until docker exec zenofcode-postgres pg_isready -U $(POSTGRES_DB) > /dev/null 2>&1; do \
		echo "🔄 Still waiting..."; \
		sleep 2; \
	done
	@echo "✅ PostgreSQL is ready."

logs:
	@docker compose logs -f postgres

run-migration:
	@echo "🔄 Running Alembic migrations..."
	alembic upgrade head
	@echo "✅ Migrations completed!"

db-reset:
	@echo "⚠️  This will delete all PostgreSQL data and remove volumes!"
	@read -p "Are you sure? This cannot be undone (y/N): " confirm && \
	if [ "$$confirm" = "y" ]; then \
		docker compose down -v && \
		echo " DB volume removed. Ready for a clean start."; \
	else \
		echo " Reset cancelled."; \
	fi

new-migration:
	@if [ -z "$(msg)" ]; then \
		echo "❌ ERROR: Please provide a message. Usage: make new-migration msg='add courses table'"; \
		exit 1; \
	fi
	@echo "📝 Creating new Alembic migration: $(msg)"
	@pipenv run alembic revision --autogenerate -m "$(msg)"
	@echo "✅ Migration file created in alembic/versions/"
