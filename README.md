# FastAPI application project structure

## Overview

This Bash script generates a skeleton structure for a FastAPI-based application. It automates the creation of essential directories, files, and configurations to quickly get you started with a FastAPI project.

## Features

- Automatically generates a directory structure for a FastAPI application.
- Creates and populates files such as:
  - `Dockerfile` for containerization.
  - `.gitignore` for ignoring unnecessary files in Git.
  - `.dockerignore` to exclude files from Docker builds.
  - `requirements/base.txt` for dependency management.
  - A sample FastAPI `main.py` file with example routes.
  - `compose.yml` for Docker Compose setup.
- Installs and sets up a Python virtual environment.
- Installs FastAPI and its required dependencies.

## Usage

### Prerequisites

- Bash shell (Linux/macOS/WSL) installed.
- Python 3.10+ installed.

### Running the Script

1. Run the script with the following syntax:
   ```bash
   ./skeleton.sh <project_name> <python_path>
   ```
   - `<project_name>`: The name of the project (e.g., `my_fastapi_app`).
   - `<python_path>`: The path to the Python executable (e.g., `/usr/bin/python3`).

2. Example:
   ```bash
   ./skeleton.sh my_fastapi_app /usr/bin/python3
   ```
