# DF Automation & Robotics Application Suite — Project Context & Architecture

> **Document Purpose:** This document serves as the persistent cross-session architectural and operational reference for Antigravity AI agents and developers working on the `DF_application` workspace.

---

## 1. System Overview & Mission

The **DF Application Suite** is a unified multi-application ecosystem built for **DF Automation and Robotics**. It decouples distinct engineering, operational, and customer-facing tools into independent modular applications while providing a centralized access gateway.

### The Single Entry Point Concept (The Portal Hub)
- Users only need to access the **Central Portal** (`http://localhost:8080`).
- The portal acts as the front door / launchpad, displaying the real-time status and quick-access links to each dedicated application running on its designated port.

---

## 2. Application Registry & Port Mappings

| Application | Git Submodule Directory | Port | Primary Purpose & User Workflow | Tech Stack |
| :--- | :--- | :--- | :--- | :--- |
| **Central Portal Hub** | `portal/` | `8080` | **Front Gateway Launchpad:** Central interface for users to select, monitor, and launch any DF robotics web tool. | Python `http.server`, Tailwind CSS, HTML5 |
| **DF AI Chatbot** | `dfchatbot/` | `5000` | **AI Robotics Assistant:** Multimodal RAG assistant for querying technical manuals (NavWiz, DFleet) with diagram/schematic visual search. | Python Flask, ChromaDB, Gemini 2.0/3.5, Waitress |
| **Site Readiness App** | `site-readiness/` | `3000` | **AGV Site Assessment Tool:** Evaluates customer physical sites (flooring, Wi-Fi, ramps, clearances) to verify suitability for AGV installation & exports readiness PDF reports. | Python Flask / Vite TS / React, ReportLab, Waitress |
| **Preventive Maintenance** | `preventive-maintenance/` | `8000` | **Robot Maintenance & Audit Tool:** Manages periodic robot health audits, hardware checklists (chassis, sensors, battery), and generates inspection reports. | Python Flask, ReportLab, Waitress |

---

## 3. Directory & Submodule Topology

```
DF_application/                     # Monorepo / Master workspace
├── .gitmodules                     # Git submodule registration
├── .gitignore                      # Workspace-level gitignore
├── README.md                       # User-facing onboarding & run instructions
├── PROJECT_CONTEXT.md              # Cross-session technical reference (This file)
├── start_all.sh                    # Master startup script (Linux / macOS)
├── start_all.bat                   # Master startup script (Windows)
├── stop_all.sh                     # Master shutdown script (Linux / macOS)
│
├── portal/                         # Submodule: Central Gateway (Port 8080)
│   ├── index.html                  # Responsive dark-mode dashboard with live health checks
│   └── server.py                   # Lightweight Python HTTP server
│
├── dfchatbot/                      # Submodule: Multimodal RAG Chatbot (Port 5000)
│   ├── .venv/                      # Isolated Python virtual environment
│   ├── requirements.txt            # Python dependencies (ChromaDB, google-genai, etc.)
│   ├── src/                        # Core RAG engine, embedders, query pipelines
│   ├── scripts/run_server.py       # Production server launcher (Waitress WSGI)
│   └── PROJECT_CONTEXT.md          # In-depth technical guide for dfchatbot
│
├── site-readiness/                 # Submodule: AGV Site Assessment (Port 3000)
│   ├── .venv/                      # Isolated Python virtual environment
│   ├── requirements.txt            # Python dependencies (Flask, ReportLab, etc.)
│   ├── app.py                      # Flask API & report generation backend
│   └── scripts/run_server.py       # Production server launcher (Waitress WSGI)
│
└── preventive-maintenance/         # Submodule: Maintenance Checklist (Port 8000)
    ├── .venv/                      # Isolated Python virtual environment
    ├── requirements.txt            # Python dependencies (Flask, ReportLab, etc.)
    └── app.py                      # Flask web application & inspection engine
```

---

## 4. Virtual Environment & Dependency Isolation

Each submodule operates in its own isolated Python virtual environment (`.venv`) to prevent dependency conflicts (e.g., ChromaDB, NumPy, ReportLab versions).

### Environment Initialization
- **`dfchatbot`**:
  ```bash
  cd dfchatbot && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
  ```
- **`site-readiness`**:
  ```bash
  cd site-readiness && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
  ```
- **`preventive-maintenance`**:
  ```bash
  cd preventive-maintenance && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
  ```
- **`portal`**:
  Uses standard Python 3 runtime without external dependencies.

---

## 5. Startup & Process Orchestration

### Master Scripts
- **Start All**: `./start_all.sh` (or `start_all.bat` on Windows)
  - Iterates through each submodule.
  - Automatically activates the respective `.venv` if present.
  - Launches each background server with designated logging outputs (`dfchatbot.log`, `site_readiness.log`, `pm.log`, `portal.log`).
  - Records process IDs into `.running_pids`.
- **Stop All**: `./stop_all.sh`
  - Terminates recorded PIDs and ensures ports `8080`, `5000`, `3000`, and `8000` are released.

---

## 6. Git Submodule Workflow Rules

1. **Independent Submodules**: Each directory (`dfchatbot/`, `portal/`, `site-readiness/`, `preventive-maintenance/`) is backed by its own remote GitHub repository under the `tolokedf` organization.
2. **Submodule Commit & Push**:
   - Make code edits inside the specific submodule.
   - Commit and push from within that submodule directory (`git commit -m "..." && git push origin main`).
   - If submodule pointers are updated, commit the updated pointer in the root `DF_application` repository.
3. **Cloning Workflow**:
   - `git clone --recurse-submodules https://github.com/tolokedf/DF_application.git`
   - Or initialize existing clone: `git submodule update --init --recursive`

---

## 7. Guidelines for Antigravity Sessions

When interacting with this codebase in any Antigravity session:
- **Naming Rule**: The AI chatbot application is named **`dfchatbot`** (legacy name `df_rag_project` is deprecated).
- **Port Rules**: Always preserve standard port assignments:
  - Portal: `8080`
  - Chatbot: `5000`
  - Site Readiness: `3000`
  - Preventive Maintenance: `8000`
- **Virtual Environments**: Always use the respective submodule's `.venv` (`source .venv/bin/activate` or invoke `.venv/bin/python`) when running scripts, tests, or installing packages.
