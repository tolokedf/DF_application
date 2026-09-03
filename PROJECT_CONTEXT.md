# DF Automation & Robotics Application Suite — Project Context & Architecture

> **Document Purpose:** This document serves as the persistent cross-session architectural and operational reference for Antigravity AI agents and developers working on the `DF_application` workspace.

---

## 1. System Overview & Mission

The **DF Application Suite** is a unified multi-application ecosystem built for **DF Automation and Robotics**. It decouples distinct engineering, operational, and customer-facing tools into independent modular applications while providing a centralized access gateway.

### The Single Entry Point Concept (The Portal Hub)
- Users access the **Central Portal** (`http://localhost:8080` or `http://<LAN_IP>:8080`).
- The portal acts as the front door / launchpad, displaying the real-time status and quick-access links to each dedicated application running on its designated port.
- Dynamic host resolution (`window.location.hostname`) ensures that any client device on the local Wi-Fi or LAN can access all tools seamlessly using the host machine's IP address.

---

## 2. Application Registry & Port Mappings

| Application | Git Submodule Directory | Port | Primary Purpose & User Workflow | Tech Stack |
| :--- | :--- | :--- | :--- | :--- |
| **Central Portal Hub** | `portal/` | `8080` | **Front Gateway Launchpad:** Central interface for users to select, monitor, and launch any DF robotics web tool. | Python `http.server`, Tailwind CSS, HTML5 |
| **DF AI Chatbot** | `dfchatbot/` | `5000` | **AI Robotics Assistant:** Multimodal RAG assistant for querying technical manuals (NavWiz, DFleet) with diagram/schematic visual search. | Python Flask, ChromaDB, Gemini 2.0/3.5, Waitress WSGI |
| **Site Readiness App** | `site-readiness/` | `3000` | **AGV Site Assessment Tool (FRM-FLD-003):** Evaluates customer physical sites (flooring, Wi-Fi, ramps, clearances), captures 1 photo per section, tracks action items & exports official PDF reports. | Python Flask, ReportLab 5.0, Tailwind CSS, Waitress WSGI |
| **Preventive Maintenance** | `preventive-maintenance/` | `8000` | **Robot Maintenance & Audit Tool:** Dynamically discovers AGV families in `AGV_type/`, performs step-by-step SOP inspections, auto-fills form data, signs digitally, and exports official PDF/HTML reports matching source templates. | Python Flask, ReportLab 5.0, Tailwind CSS, Waitress WSGI |

---

## 3. Directory & Submodule Topology

```
DF_application/                     # Monorepo / Master workspace
├── .gitmodules                     # Git submodule registration
├── .gitignore                      # Workspace-level gitignore (ignores data/, logs, pids)
├── README.md                       # User-facing onboarding & run instructions
├── PROJECT_CONTEXT.md              # Cross-session technical reference (This file)
├── start_all.sh                    # Master startup script (Linux / macOS) with LAN IP banner
├── start_all.bat                   # Master startup script (Windows) with LAN IP banner
├── stop_all.sh                     # Master shutdown script (Linux / macOS)
│
├── portal/                         # Submodule: Central Gateway (Port 8080)
│   ├── index.html                  # Responsive dark-mode dashboard with live health checks
│   └── server.py                   # Lightweight Python HTTP server binding 0.0.0.0
│
├── dfchatbot/                      # Submodule: Multimodal RAG Chatbot (Port 5000)
│   ├── .venv/                      # Isolated Python virtual environment
│   ├── requirements.txt            # Python dependencies (ChromaDB, google-genai, waitress, etc.)
│   ├── data/                       # Isolated runtime storage (.gitignored)
│   │   ├── source_docs/            # Source technical PDF manuals
│   │   ├── output/chroma_db/       # 688 embedded manual vector chunks
│   │   └── user_storage/           # SQLite users_and_chats.db, profile pictures, uploads
│   ├── src/                        # Core RAG engine, embedders, query pipelines, auth
│   ├── scripts/run_server.py       # Production server launcher (Waitress WSGI)
│   ├── templates/                  # Frontend UI (index.html, admin.html)
│   └── PROJECT_CONTEXT.md          # Technical reference for dfchatbot
│
├── site-readiness/                 # Submodule: AGV Site Assessment FRM-FLD-003 (Port 3000)
│   ├── .venv/                      # Isolated Python virtual environment
│   ├── requirements.txt            # Python dependencies (Flask, ReportLab, waitress)
│   ├── app.py                      # Flask API & report management backend
│   ├── report_generator.py         # Official FRM-FLD-003 ReportLab PDF engine
│   ├── data/                       # Isolated runtime storage (.gitignored)
│   │   ├── checklist_template.json # Canonical 8-section FRM-FLD-003 criteria
│   │   ├── uploads/                # Section evidence photos
│   │   └── db.json                 # Audit records database
│   ├── scripts/run_server.py       # Production server launcher (Waitress WSGI)
│   └── templates/index.html        # Interactive site assessment UI with photo upload
│
└── preventive-maintenance/         # Submodule: Maintenance Checklist (Port 8000)
    ├── .venv/                      # Isolated Python virtual environment
    ├── requirements.txt            # Python dependencies (Flask, ReportLab, waitress)
    ├── app.py                      # Flask web application & dynamic SOP engine
    ├── report_generator.py         # Official Maintenance Form ReportLab PDF engine
    ├── AGV_type/                   # Dynamic AGV model family definitions
    │   └── Zalpha/                 # Zalpha AGV series folder
    │       ├── zalpha_v3_3_robot.json   # FRM/CS/015-V1.0 schema template
    │       ├── auto_charger.json        # FRM/CS/004-V1.3 schema template
    │       ├── hooking_payload.json     # FRM/CS/014-V1.0 schema template
    │       └── towing_payload.json      # FRM/CS/013-V1.0 schema template
    ├── data/                       # Isolated runtime storage (.gitignored)
    │   ├── uploads/                # Maintenance photo attachments
    │   └── db.json                 # Saved inspection reports database
    ├── scripts/run_server.py       # Production server launcher (Waitress WSGI)
    └── templates/
        ├── index.html              # Step-by-step SOP maintenance wizard
        └── report_print.html       # Printable HTML replica of official forms
```

---

## 4. Key Architectural Standards & Rules

### 1. Data Isolation Rule (`**/data/`)
- Runtime data (SQLite databases, vector embeddings, uploaded photos, report JSONs) must strictly reside inside `data/` subdirectories.
- All `data/` folders are ignored in `.gitignore`.
- This guarantees that pulling updates from GitHub to deployment machines (or swapping branches) will **never** overwrite user databases or active audit logs.

### 2. Dynamic AGV Discovery (`AGV_type/`)
- In `preventive-maintenance`, the backend dynamically scans `AGV_type/` for any subdirectories.
- Adding a new AGV model (e.g. `AGV_type/Titan/titan_v1.json`) automatically makes it available in the web UI dropdown without modifying python backend code.

### 3. ReportLab PDF Generation
- Both `site-readiness` and `preventive-maintenance` contain standalone `report_generator.py` modules that construct pixel-accurate PDF documents using ReportLab.
- Outputs match official DF Automation & Robotics corporate forms (`FRM-FLD-003`, `FRM/CS/015-V1.0`, etc.) with dual-column headers, rating tables, checkboxes, embedded photo evidence, and digital signature lines.

### 4. Wi-Fi & LAN Network Routing
- Servers bind to `0.0.0.0` to permit remote access across the local network.
- Web UI links dynamically resolve `window.location.hostname` so mobile tablets or engineer laptops on the same Wi-Fi can navigate between apps without hardcoded `localhost` issues.

---

## 5. Startup & Process Orchestration

### Master Scripts
- **Start All**: `./start_all.sh` (or `start_all.bat` on Windows)
  - Detects host machine's Wi-Fi / LAN IP address.
  - Launches each application using Waitress WSGI with multi-threaded worker pools.
  - Unbuffered logging (`python -u`) output into `dfchatbot.log`, `site_readiness.log`, `pm.log`, `portal.log`.
  - Displays a shareable LAN link banner for remote devices.
- **Stop All**: `./stop_all.sh`
  - Gracefully releases ports `8080`, `5000`, `3000`, and `8000`.

---

## 6. Git Submodule Workflow Rules

1. **Remote Organization**: All repositories are hosted under `https://github.com/tolokedf/`.
2. **Submodule Commit & Push**:
   - Make code edits inside the specific submodule.
   - Commit and push from within that submodule directory (`git commit -m "..." && git push origin main`).
   - Commit and push the updated submodule commit pointer in the root `DF_application` repository.
3. **Cloning Workflow**:
   - `git clone --recurse-submodules https://github.com/tolokedf/DF_application.git`
   - Or initialize existing clone: `git submodule update --init --recursive`
