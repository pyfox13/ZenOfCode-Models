# Use modern Dockerfile features (BuildKit)
# Enables better caching and syntax support
# (does NOT change runtime behavior by itself)
# syntax=docker/dockerfile:1.5


############################
# Build stage
# Purpose:
# - Prepare dependency artifacts (wheels)
# - Do all "heavy" work here (compilers, pipenv)
############################
FROM python:3.10-slim AS builder

# Python runtime hygiene:
# - Don't create .pyc files (keeps image clean)
# - Don't buffer stdout/stderr (logs appear immediately)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# All commands now run relative to /app
WORKDIR /app

# Install OS-level build tools
# Needed only to compile Python deps with native extensions
# (--no-install-recommends keeps image smaller)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Pipenv (build-time tool only)
# Used to read Pipfile.lock and export pinned dependencies
RUN pip install --no-cache-dir pipenv

# Copy ONLY dependency manifests first
# This enables Docker layer caching:
# dependencies are rebuilt only when Pipfile.lock changes
COPY Pipfile Pipfile.lock /app/

# Convert Pipfile.lock into a pip-compatible requirements.txt
# --dev includes runtime + test dependencies (pytest, etc.)
RUN pipenv requirements --dev > /app/requirements.txt

# Build wheels for ALL dependencies listed in requirements.txt
# Wheels are prebuilt installable artifacts (.whl files)
# These will be used later for fast, offline installs
RUN pip wheel --no-cache-dir --wheel-dir /app/wheels -r /app/requirements.txt


############################
# Runtime stage
# Purpose:
# - Install dependencies from prebuilt wheels
# - Copy source code
# - Run tests as a non-root user
############################
FROM python:3.10-slim AS runtime

# Same Python hygiene settings as builder
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Create a non-root user for security
# Container will run as this user
RUN addgroup --system app && adduser --system --ingroup app app

# Copy dependency artifacts from builder stage
# - requirements.txt = exact dependency list
# - wheels/ = prebuilt dependency files
COPY --from=builder /app/requirements.txt /app/requirements.txt
COPY --from=builder /app/wheels /app/wheels

# Install dependencies:
# - --no-index: do NOT access the internet
# - --find-links: install ONLY from local wheels
# This guarantees deterministic, fast installs
RUN pip install --no-cache-dir --no-index --find-links=/app/wheels -r /app/requirements.txt \
    && rm -rf /app/wheels /app/requirements.txt

# Copy application source code
# Tests will run directly from source (not from installed package)
COPY . /app

# Drop privileges: run container as non-root user
USER app

# No CMD defined intentionally:
# - tests are triggered via `docker run ... pytest`
# - or via Makefile / CI
