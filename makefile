# ==========================================
# 🧱 Makefile for ZenOfCode – Models
# Docker-based test runner for model layer
# ==========================================

SHELL := /bin/bash

# Docker image name (scoped + explicit)
IMAGE_NAME=zenofcode/models-test

# ------------------------------------------
# Help
# ------------------------------------------
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  models-build   - Build the models Docker test image"
	@echo "  models-test    - Run model tests inside Docker"
	@echo "  models-shell   - Open a shell inside the models test container"
	@echo "  models-clean   - Remove the Docker image"

# ------------------------------------------
# Build image (test stage)
# ------------------------------------------
.PHONY: models-build
models-build:
	@echo "🚀 Building models test container..."
	@docker build --target test -t $(IMAGE_NAME) .
	@echo "✅ Models test image built"

# ------------------------------------------
# Run tests
# ------------------------------------------
.PHONY: models-test
models-test: models-build
	@echo "🧪 Running model tests..."
	@docker run --rm $(IMAGE_NAME)
	@echo "✅ Tests complete"

# ------------------------------------------
# Interactive shell
# ------------------------------------------
.PHONY: models-shell
models-shell: models-build
	@echo "🐚 Launching shell in models container..."
	@docker run -it --rm $(IMAGE_NAME) /bin/sh

# ------------------------------------------
# Cleanup
# ------------------------------------------
.PHONY: models-clean
models-clean:
	@echo "🧹 Removing models image (if exists)..."
	@docker rmi $(IMAGE_NAME) || true
