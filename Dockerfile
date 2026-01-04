# syntax=docker/dockerfile:1.5

############################
# Builder stage
############################
FROM python:3.10-slim AS builder

# Python runtime hygiene:
# - Don't create .pyc files (keeps image clean)
# - Don't buffer stdout/stderr (logs appear immediately)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Build tools for compiling wheels (if any deps require it)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy full source (required to build a real wheel)
COPY . /app

# Build the package wheel + build wheels for dev extras (offline install later)
RUN pip install --no-cache-dir build \
 && python -m build --wheel \
 && pip wheel --no-cache-dir --wheel-dir /app/wheels ".[dev]"

############################
# Test stage (has pytest)
############################
FROM python:3.10-slim AS test

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Install from prebuilt wheels (no internet)
COPY --from=builder /app/wheels /app/wheels
RUN pip install --no-cache-dir --no-index --find-links=/app/wheels "zenofcode-models[dev]" \
 && rm -rf /app/wheels

# Copy source (tests + any local tooling)
COPY . /app

# Default test command (Makefile can override)
CMD ["pytest"]

############################
# Runtime stage (minimal)
############################
FROM python:3.10-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Non-root user
RUN addgroup --system app && adduser --system --ingroup app app

# Install ONLY runtime package from prebuilt wheels (no internet)
COPY --from=builder /app/wheels /app/wheels
RUN pip install --no-cache-dir --no-index --find-links=/app/wheels zenofcode-models \
 && rm -rf /app/wheels

USER app
