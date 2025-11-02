# 📝 Flask To-Do App (with AWS DynamoDB)

A minimal Flask web application that provides a simple to-do list interface.  
Tasks are stored in an AWS DynamoDB table (or a mock database in tests).  
Perfect for demonstrating build pipelines, Docker deployments, and AWS integrations.

---

## 🚀 Features

- Web UI to **add** and **delete** tasks  
- Uses **AWS DynamoDB** as backend storage  
- Includes **unit tests** with mocked AWS (via `moto`)  
- Fully runnable in Docker  
- Supports **uv** or **venv** for dependency management  

---

## 🧰 Requirements

- Python 3.13 
- AWS credentials (if you want to connect to a real DynamoDB instance)  
- [uv](https://github.com/astral-sh/uv) *(optional but recommended)*  

---

## ⚙️ Setup Instructions

### Option 1: Using `uv` (recommended)
```bash
# 1. Install dependencies
uv sync --dev

# 2. Run tests
uv run pytest

# 3. Run the Flask app locally
uv run python app.py
```
