# DF Automation & Robotics Application Suite

A unified multi-application workspace for **DF Automation and Robotics**. Each web application operates as an independent Git submodule with its own isolated virtual environment (`.venv`), dependencies, and designated port number, accessible via the **Central Portal Hub**.

---

## 🚪 Single Entry Point: Central Portal Hub

Users only need to open the **Central Portal Hub** to monitor and launch any application in the suite:

📍 **Central Portal Hub**: [http://localhost:8080](http://localhost:8080)

---

## 🗺️ Application Registry & Port Assignments

| Application | Directory / Submodule | Port | Purpose & Workflow | Tech Stack |
| :--- | :--- | :--- | :--- | :--- |
| **Central Portal Hub** | `portal/` | `8080` | **Front Gateway**: Central launchpad & live status monitor for all DF web tools. | HTML5, Tailwind CSS, Python |
| **DF AI Chatbot** | `dfchatbot/` | `5000` | **AI Technical Assistant**: Multimodal RAG chatbot for robotics manuals (NavWiz & DFleet) with visual schematic search. | Python Flask, ChromaDB, Gemini 2.0/3.5 |
| **Site Readiness App** | `site-readiness/` | `3000` | **AGV Site Assessment**: Evaluates client facilities (flooring, Wi-Fi, ramps, clearance) to verify AGV installation suitability & generates readiness verification reports. | React / Vite, Python Flask, ReportLab |
| **Preventive Maintenance** | `preventive-maintenance/` | `8000` | **Robot Maintenance**: Periodic AMR health audits, hardware component checklists, and PDF service report generation. | Python Flask, ReportLab, Gemini AI |

---

## 🚀 Quick Start (Launch All Services)

### 1. Setup Virtual Environments (First-time Setup)
Each application runs with its own isolated `.venv`:

```bash
# DF Chatbot (Port 5000)
cd dfchatbot && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt && deactivate && cd ..

# Site Readiness (Port 3000)
cd site-readiness && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt && deactivate && cd ..

# Preventive Maintenance (Port 8000)
cd preventive-maintenance && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt && deactivate && cd ..
```

### 2. Launch All Applications

#### Linux / macOS:
```bash
./start_all.sh
```

#### Windows:
Double-click `start_all.bat` or run:
```cmd
start_all.bat
```

Open [http://localhost:8080](http://localhost:8080) in your browser.

### 3. Stop All Services
```bash
./stop_all.sh
```

---

## 🛠️ Individual Submodule Management & Git Workflow

Each application is an independent Git submodule connected to its own GitHub repository.

### Initializing / Cloning Repository with Submodules
```bash
# When cloning for the first time
git clone --recurse-submodules https://github.com/tolokedf/DF_application.git

# Or if cloned without submodules
git submodule update --init --recursive
```

### Working on an Individual App
```bash
# 1. Navigate to submodule directory
cd dfchatbot  # or site-readiness / preventive-maintenance / portal

# 2. Activate its dedicated environment
source .venv/bin/activate

# 3. Work on code, test, and commit to its remote repo
git add .
git commit -m "feat: your feature"
git push origin main
```

---

## ⚙️ Project Technical Reference

For architectural decisions, deep-dive component schemas, and AI agent guidelines across sessions, refer to [PROJECT_CONTEXT.md](file:///home/tinonn/DF_application/PROJECT_CONTEXT.md).
