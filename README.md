# DF Application Suite

A modular multi-application monorepo for DF Robotics dedicated web tools. Each application is completely decoupled, maintaining its own dependencies, environment configurations, and independent Git repositories.

---

## 🗺️ Application Port Registry

| Application | Directory | Tech Stack | Local URL | Git Repo |
| :--- | :--- | :--- | :--- | :--- |
| **Central Portal Hub** | `portal/` | HTML5 / Vanilla JS / Python | [http://localhost:8080](http://localhost:8080) | Local Hub |
| **AI Chatbot (RAG)** | `df_rag_project/` | Python Flask / ChromaDB / Gemini | [http://localhost:5000](http://localhost:5000) | `github.com/tolokedf/dfchatbot` |
| **Site Readiness** | `site-readiness/` | React 19 / Express TS / Vite | [http://localhost:3000](http://localhost:3000) | Independent Repo |
| **Preventive Maintenance** | `preventive-maintenance/` | Flask / Report Engine / Gemini | [http://localhost:8000](http://localhost:8000) | Independent Repo |

---

## 🚀 Quick Start (All Apps)

### Linux / macOS
```bash
./start_all.sh
```
To stop all services:
```bash
./stop_all.sh
```

### Windows
Double-click `start_all.bat` or run:
```cmd
start_all.bat
```

---

## 🛠️ Individual App Management & Git Workflow (Option 1 Multi-Repo)

Each application has its own Git repository inside its directory:

### 1. DF RAG Chatbot
```bash
cd df_rag_project
source .venv/bin/activate    # Linux
# or .venv\Scripts\activate  # Windows
git status
git commit -m "your update"
git push origin main
```

### 2. Site Readiness
```bash
cd site-readiness
npm install
npm run dev
git init                    # (If initializing new git repo)
git add .
git commit -m "initial commit"
```

### 3. Preventive Maintenance Report
```bash
cd preventive-maintenance
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```
