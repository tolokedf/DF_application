# AGENTS.md — Cross-Session Reference & Core Agent Directives

> **Workspace:** DF Application Suite (`DF_application`)  
> **Target Audience:** All AI Coding Assistants, Antigravity Agents, and Developers

---

## 🚨 1. Mandatory Scope Directive (Strictly Enforced)

> ### **CRITICAL RULE:**
> **Do not add additional feature/button/text that did not mention in instruction.**
>
> - **Strict Adherence:** Implement, modify, or delete **only** what is explicitly requested in the user prompt.
> - **Zero Unsolicited UI Additions:** Never add extra buttons, search bars, toggle switches, cards, badges, icons, demo widgets, or descriptive copy unless specifically asked.
> - **Preserve Existing Behavior:** Never strip, alter, or break unrelated features, endpoints, or UI layouts.
> - **Clean & Minimal:** Keep code and interfaces focused entirely on the requested scope.

---

## 🧭 2. Multi-App Architecture & Port Registry

The monorepo coordinates 4 independent web applications. Each app has its own environment and dependencies.

| Application | Directory / Submodule | Port | Core Purpose | Tech Stack |
| :--- | :--- | :--- | :--- | :--- |
| **Central Portal Hub** | `portal/` | **8080** | Central gateway dashboard with real-time health checks & theme switcher. | HTML5, Tailwind CSS, Python `http.server` |
| **DF AI Chatbot** | `dfchatbot/` | **5000** | Multimodal Vision RAG assistant for robotics manuals (NavWiz, DFleet). | Python Flask, ChromaDB, Gemini 2.0/3.5, Waitress |
| **Site Readiness App** | `site-readiness/` | **3000** | AGV site assessment tool (FRM-FLD-003) with photo uploads & PDF export. | Python Flask, ReportLab 5.0, Waitress |
| **Preventive Maintenance** | `preventive-maintenance/` | **8000** | SOP maintenance checklist, dynamic AGV discovery & PDF generator. | Python Flask, ReportLab 5.0, Waitress |

---

## 🛡️ 3. Core Architectural Standards

1. **Data Isolation (`**/data/`)**:
   - All runtime databases (`.sqlite3`, `db.json`), vector stores, user uploads (`uploads/`), and generated PDFs must reside strictly inside `data/` subdirectories.
   - All `data/` folders are `.gitignore`d to prevent committing operational data.

2. **Network & Host Resolution**:
   - Servers bind to `0.0.0.0` for access across the local network / Wi-Fi.
   - Web UIs dynamically use `window.location.hostname` rather than hardcoding `localhost`.

3. **Portal & Design System**:
   - Central portal runs on Google Material Design 3 styling.
   - 3-mode theme selector (**Light** / **Dark** / **Device default (System)**) with `localStorage` persistence (`'df_portal_theme'`).

---

## 🚀 4. Startup & Process Orchestration

- **Start All Services:**
  - Linux / macOS: `./start_all.sh`
  - Windows: `start_all.bat`
  *(Detects host LAN IP, starts all 4 servers via Waitress WSGI, and logs output)*

- **Stop All Services:**
  - Linux / macOS: `./stop_all.sh`
  *(Kills processes on ports 8080, 5000, 3000, and 8000)*

---

## 📦 5. Git Submodule Workflow

- Submodule repositories are under `https://github.com/tolokedf/`.
- Commit changes inside the submodule first: `cd <submodule> && git commit -m "..." && git push origin main`
- Then commit the updated submodule commit pointer in the root repo.
