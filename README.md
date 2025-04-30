# 🧠 ZenOfCode Models

This repository contains the **PostgreSQL database models and Alembic migrations** for the ZenOfCode platform.

For now, the `zenofcode-models` are used **directly inside the `zenofcode-backend`**. Migrations are created and applied from this repository using Pipenv and Docker.

---

## 💻 Development Setup

### 1. Install Python Dependencies
We use **Pipenv** for dependency management.

```bash
pipenv install
```

(Optional) Activate the virtual environment:

```bash
pipenv shell
```

### 2. Configure Environment Variables
Create a `.env` file in the root of this repository with the following content:

```env
POSTGRES_USER=zenofcode
POSTGRES_PASSWORD=zenofcode123
POSTGRES_DB=zenofcode_models
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
```

---

## 🐘 PostgreSQL Setup (via Docker)

We use Docker Compose to manage the PostgreSQL container for local development.

### Common Makefile Commands

| Command | Description |
|---------|-------------|
| `make db-up` | Start PostgreSQL container and wait until it's ready |
| `make db-down` | Stop the container (preserves volume/data) |
| `make db-restart` | Restart container cleanly |
| `make db-reset` | 🔥 Remove container and volume (wipes DB data) |
| `make logs` | View PostgreSQL container logs |
| `make db-wait` | Wait for DB to be ready (used internally) |

---

## 🔁 Alembic Migrations

We use Alembic to manage database migrations. These are auto-generated from SQLAlchemy models.

### Migration Commands

| Command | Description |
|---------|-------------|
| `make new-migration msg="message"` | Autogenerate a new Alembic migration from model changes |
| `make run-migration` | Apply all unapplied migrations to the database |

> Make sure you’ve added or modified a model before running `new-migration`.

### Example Usage

```bash
make new-migration msg="add users table"
make run-migration
```

Migration files are stored in `alembic/versions/`.

---

## 📂 Project Structure

```
zenofcode-models/
├── models/                    # SQLAlchemy models
│   ├── base.py
│   └── course.py
├── alembic/                   # Alembic migration logic
│   ├── versions/              # Migration revision files
│   └── env.py
├── alembic.ini                # Alembic DB config
├── tests/                     # Unit tests (TBD)
├── Pipfile / Pipfile.lock     # Pipenv-managed dependencies
├── .env                       # Environment variables for local DB
└── Makefile                   # Developer commands (DB, Alembic)
```

---

## 🧪 Example DB Operations (psql)

To manually inspect or test your database:

### Enter the DB Console:
```bash
docker exec -it zenofcode-postgres psql -U zenofcode -d zenofcode_models
```

### View All Tables:
```sql
\dt *.*
```

### Insert Sample Data:
```sql
INSERT INTO courses (name, description) VALUES ('Python Basics', 'Intro to Python');
```

### Query Table:
```sql
SELECT * FROM courses;
```

---

## 🧠 Development Philosophy

| Topic | Approach |
|-------|----------|
| Model packaging | ❌ Not packaged yet — directly used in backend |
| Database schema | ✅ Single schema (`public`) inside one DB |
| Migrations | ✅ Managed locally via Alembic and Makefile |
| Multi-service support | ❌ Not yet — future packaging possible |

---

## 🔮 Future Roadmap

- ✅ Tight integration with backend for MVP
- 🔄 Optional packaging and versioning post-MVP
- 🚀 Possible multi-schema or multi-DB support for microservices
- 🔐 Secure DB credential handling in CI/CD

---

## 📄 License
© ZenOfCode Team (Fox, ZerOo)
