if [ -z "$1" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Usage: $0 <python_path>"
  exit 1
fi

PROJECT_NAME=$1
PYTHON_PATH=$2

# Define and create the directory structure
DIRECTORIES=(
 "$PROJECT_NAME/tests"
  "$PROJECT_NAME/docs"
  "$PROJECT_NAME/config"
  "$PROJECT_NAME/logs"
  "$PROJECT_NAME/requirements"
  "$PROJECT_NAME/src/common"
  "$PROJECT_NAME/src/modules"
  "$PROJECT_NAME/src/models/base"
)
for DIR in "${DIRECTORIES[@]}"; do
  mkdir -p "$DIR"
done

FILES=(
  "$PROJECT_NAME/README.md"
  "$PROJECT_NAME/Dockerfile"
  "$PROJECT_NAME/compose.yml"
  "$PROJECT_NAME/.gitignore"
  "$PROJECT_NAME/.dockerignore"
  "$PROJECT_NAME/.env"
  "$PROJECT_NAME/.env.sample"
  "$PROJECT_NAME/requirements/base.txt"
  "$PROJECT_NAME/src/__init__.py"
  "$PROJECT_NAME/src/main.py"
  "$PROJECT_NAME/src/common/__init__.py"
  "$PROJECT_NAME/src/common/database.py"
  "$PROJECT_NAME/src/common/swagger.py"
  "$PROJECT_NAME/src/common/logger.py"
  "$PROJECT_NAME/src/common/constants.py"
  "$PROJECT_NAME/src/modules/__init__.py"
  "$PROJECT_NAME/src/models/__init__.py"
  "$PROJECT_NAME/src/models/base/__init__.py"
  "$PROJECT_NAME/src/models/base/repository.py"
)

for FILE in "${FILES[@]}"; do
  touch "$FILE"
done

curl -s https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore >> "$PROJECT_NAME/.gitignore"

$PYTHON_PATH -m venv $PROJECT_NAME/venv && source $PROJECT_NAME/venv/bin/activate
pip install -q --upgrade pip && pip install "fastapi[standard]"
pip freeze > $PROJECT_NAME/requirements/base.txt


cat <<EOL > "$PROJECT_NAME/src/main.py"
from typing import Union

from fastapi import FastAPI


app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
EOL

cat <<EOL > "$PROJECT_NAME/Dockerfile"
FROM python:3.12-slim
RUN useradd -m myuser
USER myuser
WORKDIR /app
ENV PATH="/home/myuser/.local/bin:\$PATH"
COPY ./requirements/base.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY src src
CMD ["fastapi", "run", "./src/main.py", "--host", "0.0.0.0", "--port", "8000"]
EOL


cat <<EOL > "$PROJECT_NAME/.dockerignore"
# Exclude Python cache and compiled files
__pycache__/
*.py[cod]
*.pyo

# Exclude environment files
.env
.env.*

# Exclude logs
*.log
logs/
*.pid

# Exclude virtual environments
venv/
.venv/
env/
.virtualenv/

# Exclude local development tools
.idea/
.vscode/
*.swp
*.swo

# Exclude Docker-related files (except Dockerfile)
docker-compose.yml
docker-compose.override.yml

# Exclude testing and coverage outputs
tests/
coverage/
.coverage
*.cover

# Exclude build and distribution directories
build/
dist/
*.egg-info/

# Exclude static and temporary files
staticfiles/
media/
tmp/

# Node.js dependencies (if using a frontend)
node_modules/

# Exclude unnecessary system files
.DS_Store
Thumbs.db
EOL

cat <<EOL > "$PROJECT_NAME/compose.yml"
services:
  fastapi:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: fastapifastapibackend
    restart: unless-stopped
    ports:
      - "8000:8000"
EOL

cat <<EOL > "$PROJECT_NAME/README.md"
# FastAPI Application

## Overview

This is a FastAPI-based web application designed for high-performance API development. It supports asynchronous operations, automatic OpenAPI documentation, and an intuitive developer experience.

## Features

- **FastAPI Framework**: Leverages Python's modern features for high-speed APIs.
- **Asynchronous Support**: Designed for high concurrency using Python's async/await syntax.
- **Built-in Documentation**: Auto-generates OpenAPI and Swagger UI.
- **Scalable**: Easily deployable with Docker and Kubernetes.
- **Customizable**: Ready for integration with databases, authentication, and more.

---
## Project Structure

\```
.
├── Dockerfile
├── README.md
├── compose.yml
├── config/
├── docs/
├── logs/
├── requirements/
│   └── base.txt
├── src/
│   ├── __init__.py
│   ├── common/
│   │   ├── __init__.py
│   │   ├── constants.py
│   │   ├── database.py
│   │   ├── logger.py
│   │   └── swagger.py
│   ├── main.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── base/
│   │       ├── __init__.py
│   │       └── repository.py
│   └── modules/
│       └── __init__.py
└── tests/
\```

---

## Installation

### Prerequisites

- Python 3.10+ installed
- \`pip\` for dependency management
- Docker (optional, for containerized deployment)

### Steps

1. Clone the repository:
   \```bash
   git clone https://github.com/username/project-name.git
   cd project-name
   \```

2. Install dependencies:
   \```bash
   pip install -r requirements/base.txt
   \```

3. Run the application:
   \```bash
   fastapi dev run ./src/main.py --reload
   \```

4. Access the application:
   Open [http://127.0.0.1:8000](http://127.0.0.1:8000) in your browser.

---

## API Documentation

The application automatically generates and serves OpenAPI documentation.

- **Swagger UI**: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
- **ReDoc**: [http://127.0.0.1:8000/redoc](http://127.0.0.1:8000/redoc)

---

## Deployment

### Using Docker

1. Build the Docker image:
   \```bash
   docker build -t fastapi-app .
   \```

2. Run the container:
   \```bash
   docker run -p 8000:8000 fastapi-app
   \```

3. Access the application at [http://127.0.0.1:8000](http://127.0.0.1:8000).

---

## Contributing

1. Fork the repository.
2. Create a new branch:
   \```bash
   git checkout -b feature/your-feature-name
   \```
3. Make your changes and commit them:
   \```bash
   git commit -m "Add your feature"
   \```
4. Push to your branch:
   \```bash
   git push origin feature/your-feature-name
   \```
5. Open a pull request.

---
EOL
