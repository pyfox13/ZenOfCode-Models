# ZenOfCode Models - README

This repository contains shared database models for ZenOfCode, packaged as a Python module. **Alembic migrations are generated in `zenofcode-backend`, not here.**

## 📁 Repository Structure
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
- Use **conventional commit messages** (`feat:`, `fix:`, `BREAKING CHANGE:`).
- Create a PR and get it reviewed.
- CI/CD publishes a **temporary version** (`x.y.z-pr123`) to JFrog Artifactory.

### Step 2: Test Models in `zenofcode-backend`
- Install the temporary version:
  ```bash
  pip install zenofcode-models==0.1.0-pr123
  ```
- Update backend services and migrations.
- Test changes locally and create a PR for review.

### Step 3: Merge and Deploy to QA
- Merge `zenofcode-models` PR first, creating a **stable version** from `pyproject.toml`.
- CI/CD updates `zenofcode-backend` manually to use the stable version.
- Merge `zenofcode-backend` to `develop`, triggering deployment to QA.

### Step 4: Deploy to Production
- Merge `zenofcode-backend` to `main`:
  - Deploy services to Production.
  - Run migrations on Production RDS.
  - Perform smoke tests.

## 📝 Versioning Strategy with `semantic-release`
- **PR Commits:** Auto-publish `x.y.z-pr<PR_NUMBER>` without updating `pyproject.toml`.
- **On Merge to `main`:**
  - `semantic-release` reads commit messages to determine the version.
  - Auto-bumps `version` in `pyproject.toml`.
  - Generates `CHANGELOG.md`.
  - Publishes stable version to JFrog.
  - Commits version bump back to `main`.

## 🚀 Commands Overview
- **Run Tests:** `make test`
- **Manual Bump (if needed):** `poetry version [patch|minor|major]`
- **Local Install:** `poetry install`

This workflow integrates `semantic-release` with `poetry` for automatic versioning and changelog management while maintaining manual control over stable releases. 🚀
