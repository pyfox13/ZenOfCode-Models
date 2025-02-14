# ZenOfCode Models - README

This repository contains shared database models for ZenOfCode, packaged as a Python module. **Alembic migrations are generated in `zenofcode-backend`, not here.**

## 💻 Development Environment
### Using Poetry for Dependency Management
- **Local Install:**
  ```bash
  poetry install
  ```
- **Run Tests:**
  ```bash
  poetry run pytest
  ```
- **Activate Virtual Environment:**
  ```bash
  source $(poetry env info --path)/bin/activate
  ```

## 📂 Repository Structure
```
zenofcode-models/
├── models/                    # Database models (e.g., courses.py, users.py)
├── tests/                     # Unit tests for models
├── pyproject.toml             # Project dependencies and versioning (Poetry)
├── Makefile                   # Common commands
└── README.md
```

## 🚀 End-to-End Workflow
### Step 1: Develop Models (`zenofcode-models`)
- Create or update models and run tests (`make test`).
- Follow **conventional commits** (`feat:`, `fix:`, `BREAKING CHANGE:`).
- Create a PR for review. CI/CD publishes a **temporary version** (`x.y.z-pr123`).

### Step 2: Test Models in `zenofcode-backend`
- Install the temporary version:
  ```bash
  pip install zenofcode-models==0.1.0-pr123
  ```
- Update backend services and run migrations.
- Create a PR and test locally.

### Step 3: Merge and Deploy to QA
- Merge `zenofcode-models` PR to create a stable version.
- Update `zenofcode-backend` to use the stable version.
- Merge `zenofcode-backend` into `develop` to deploy to QA.


## 📝 Versioning Strategy (`semantic-release`)
- **PR Builds:** Auto-publish `x.y.z-pr<PR_NUMBER>` without changing `pyproject.toml`.
- **On Merge to `main`:**
  - Bump version in `pyproject.toml` using commit messages.
  - Generate `CHANGELOG.md`.
  - Publish stable version.
  - Commit version bump to `main`.

## 🚀 Commands Overview
- **Run Tests:** `make test`
- **Manual Version Bump:** `poetry version [patch|minor|major]`
- **Local Install:** `poetry install`

This workflow integrates `semantic-release` with `Poetry` for automated versioning and changelog management, ensuring consistency and efficiency in CI/CD. 🚀
