# ✨ ZenOfCode Models

`zenofcode-models` is the shared **SQLAlchemy ORM + domain layer** for the ZenOfCode platform.
It is maintained as a standalone Python package and installed by `zenofcode-backend`.

This repo contains:

* SQLAlchemy model definitions
* (Optional) Pydantic schemas / enums / shared domain logic

All DB runtime concerns live in **`zenofcode-backend`**.

---

## 🚧 MVP Phase (Current) — Local Package Only

During MVP, we are **NOT publishing** this package to any registry.

Why?

* The models are changing rapidly.
* Publishing every small change would slow development.
* We want fast local iteration until the schema stabilizes.

The version still exists in `pyproject.toml` because:

* Wheels require a version number.
* We need a basic version to build artifacts and track changes internally.

---

## 🧑‍💻 Development Setup (Single Source of Truth: `pyproject.toml`)

Create a local environment and install the package in editable mode:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
```

---

## 🐳 Docker-Based Tests (Primary)

All tests run in Docker to avoid host inconsistencies:

```bash
make models-build
make models-test
```

---

## 🛠️ Local Build + Install Workflow (MVP)

### Step 1: Build the wheel

From this repo:

```bash
python -m build --wheel
```

### Step 2: Locate the wheel

```text
dist/zenofcode_models-X.Y.Z-py3-none-any.whl
```

### Step 3: Install into backend via Pipfile

Because this is not a monorepo, use an absolute path in the backend `Pipfile`:

```toml
[packages]
zenofcode-models = {file = "/absolute/path/to/zenofcode_models-X.Y.Z-py3-none-any.whl"}
```

Then run in the backend:

```bash
pipenv install
```

---

## 🚀 Future Phase (Stable + GitHub Packages)

Once the models stabilize and we are ready for release:

* Wheels built automatically in CI
* Pre-release builds for PRs (e.g., `1.4.0-dev.12`)
* Pre-release wheels published for testing
* Stable wheels published to GitHub Packages

Backend consumes pinned versions, like:

```toml
zenofcode-models = "==1.4.0"
```

This will replace the manual wheel copy process.

---

## 🧩 Versioning (Semantic Versioning + bumpver)

| Change Type | Meaning                           |
| ----------- | --------------------------------- |
| MAJOR       | Breaking changes                  |
| MINOR       | Backwards-compatible enhancements |
| PATCH       | Small fixes, docs, refactors      |

Update the version:

```bash
bumpver update --major
bumpver update --minor
bumpver update --patch
```

`bumpver` updates `pyproject.toml` automatically.

---

## 📁 Project Structure

```text
zenofcode-models/
├── zenofcode_models/          # Package root
│   └── models/                # SQLAlchemy models
│       ├── base.py
│       └── course.py
├── tests/                     # Unit tests
├── pyproject.toml             # Package metadata
├── Dockerfile                 # Test/lint/build runner
└── makefile                   # Developer commands
```

---

## 🔐 Responsibility Separation

| Concern                                 | Owned By               |
| --------------------------------------- | ---------------------- |
| ORM models, domain objects              | zenofcode-models       |
| Database engine/session                 | zenofcode-backend      |
| Psycopg2 installation                   | zenofcode-backend only |
| Alembic migrations                      | zenofcode-backend      |
| Runtime (FastAPI / Lambda / containers) | zenofcode-backend      |

This prevents environment-specific failures in the models package.

---

## 🚢 Release Checklist (When We Start Publishing)

Before publishing:

* Bump version with `bumpver`
* Build a fresh wheel: `python -m build --wheel`
* Run tests in Docker: `make models-test`
* Tag release (CI may automate this later)
* Publish wheel to internal registry

After publishing:

* Update backend dependency to the new version
* Verify backend startup + migrations

---

## 🧱 Philosophy

* Models are centralized and reusable across services.
* Migrations and DB runtime logic stay in the backend.
* Keep this repo lightweight, importable, environment-agnostic.
* Treat this project like a real internal library: versioned, installable, wheel-distributed.
