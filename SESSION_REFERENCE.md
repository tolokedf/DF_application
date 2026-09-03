# DF Application Suite — Cross-Session Reference & Developer Directives

> **Document Purpose:** This document serves as the persistent cross-session operational, architectural, and development guideline for AI assistants and human developers working across the `DF_application` workspace.

---

## 🚨 1. Golden Rules & Strict Directives

### ⚠️ Primary Directive
> **Do not add additional feature/button/text that did not mention in instruction.**
- **Strict Scope Adherence:** Only implement, edit, or remove the exact features, UI elements, text, or buttons explicitly stated in the user prompt.
- **No Unrequested Widgets:** Do not invent or attach auxiliary widgets (such as extra search bars, app launcher drawers, analytics tiles, demo buttons, or extra descriptive labels) unless the user specifically asks for them.
- **Minimalist & Clean:** Keep code, layouts, and components clean, lean, and strictly faithful to the provided instructions.
- **Preserve Unrelated Functionality:** Never strip existing required logic or break existing features unless the user specifically asks to remove or change them.

---

## 🧭 2. Multi-App Architecture & Port Registry

The workspace is structured as a root orchestrator with modular Git submodules. Each application runs independently with its own virtual environment and dependencies.

| Application | Directory / Submodule | Port | Core Purpose | Tech Stack |
| :--- | :--- | :--- | :--- | :--- |
| **Central Portal Hub** | `portal/` | **8080** | Unified gateway launchpad with live health checks and theme selector. | HTML5, Tailwind CSS, Python `http.server` |
| **DF AI Chatbot** | `dfchatbot/` | **5000** | Multimodal RAG assistant for querying robotics manuals (NavWiz, DFleet). | Python Flask, ChromaDB, Gemini 2.0/3.5, Waitress |
| **Site Readiness App** | `site-readiness/` | **3000** | AGV site assessment tool (FRM-FLD-003) with photo uploads and PDF generation. | Python Flask, ReportLab 5.0, Waitress |
| **Preventive Maintenance** | `preventive-maintenance/` | **8000** | Robot maintenance SOP checklist, component wear logs, and PDF generator. | Python Flask, ReportLab 5.0, Waitress |

---

## 🛡️ 3. Critical Architectural Standards

### 1. Data Isolation Rule (`**/data/`)
- All runtime data (SQLite databases, vector stores, user uploads, generated PDFs, and JSON audit logs) must strictly reside inside `data/` subdirectories.
- All `data/` directories are registered in `.gitignore` to prevent committing customer or runtime data to version control.

### 2. Wi-Fi & LAN Network Routing
- Servers bind to `0.0.0.0` so engineers and field technicians can access tools from mobile tablets or laptops over the local Wi-Fi / LAN.
- Web UI links dynamically resolve `window.location.hostname` instead of hardcoding `localhost`.

### 3. Central Portal UI & Theme Specifications
- **Design Language:** Google Material Design theme.
- **Theme Switcher:** 3-mode selector (**Light** / **Dark** / **Device default (System)**) with `localStorage` persistence (`'df_portal_theme'`) and instant FOUC-prevention pre-loader script in `<head>`.
- **Portal Title:** `DF Application portal`.
- **Health Check Engine:** Parallel asynchronous checks against `:5000`, `:3000`, and `:8000` with animated loading indicators and cache-busting `?_t=`.

---

## 🚀 4. Startup & Process Orchestration

### Master Scripts
- **Start All Services:**
  ```bash
  ./start_all.sh       # Linux / macOS
  start_all.bat        # Windows
  ```
  - Automatically identifies host LAN IP.
  - Launches each application on its respective port (`8080`, `5000`, `3000`, `8000`).
  - Writes background logs to `portal.log`, `dfchatbot.log`, `site_readiness.log`, and `pm.log`.

- **Stop All Services:**
  ```bash
  ./stop_all.sh        # Linux / macOS
  ```
  - Gracefully releases ports `8080`, `5000`, `3000`, and `8000`.

---

## 📦 5. Git Submodule Workflow Rules

1. **Remote Organization:** Submodules belong to `https://github.com/tolokedf/`.
2. **Submodule Changes:**
   - Commit and push changes from within the submodule directory first (`cd <submodule> && git commit -m "..." && git push origin main`).
   - Then commit and push the updated submodule pointer in the root `DF_application` repository.
3. **Cloning Workflow:**
   - Full clone with all submodules:
     ```bash
     git clone --recurse-submodules https://github.com/tolokedf/DF_application.git
     ```
   - Existing clone initialization:
     ```bash
     git submodule update --init --recursive
     ```
