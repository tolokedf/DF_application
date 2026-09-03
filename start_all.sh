#!/usr/bin/env bash
# ==============================================================================
# DF Application Suite - Master Launcher (Linux / macOS)
# Unified Python & Flask Multi-App Suite
# ==============================================================================

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================================================"
echo "          🚀 Starting DF Application Suite (Unified Python)"
echo "======================================================================"

# 1. Start Portal Hub (Port 8080)
echo "[1/4] Starting Central Portal on http://localhost:8080 ..."
python3 "$PROJECT_ROOT/portal/server.py" > "$PROJECT_ROOT/portal.log" 2>&1 &
PORTAL_PID=$!

# 2. Start DF RAG Project (Port 5000)
echo "[2/4] Starting DF RAG Chatbot on http://localhost:5000 ..."
cd "$PROJECT_ROOT/df_rag_project"
if [ -d ".venv" ]; then
    source .venv/bin/activate
    python3 scripts/run_server.py > "$PROJECT_ROOT/df_rag.log" 2>&1 &
    RAG_PID=$!
    deactivate
else
    python3 scripts/run_server.py > "$PROJECT_ROOT/df_rag.log" 2>&1 &
    RAG_PID=$!
fi

# 3. Start Site Readiness (Port 3000) - Python Flask
echo "[3/4] Starting Site Readiness (Python) on http://localhost:3000 ..."
cd "$PROJECT_ROOT/site-readiness"
if [ -d ".venv" ]; then
    source .venv/bin/activate
    python3 scripts/run_server.py > "$PROJECT_ROOT/site_readiness.log" 2>&1 &
    SITE_PID=$!
    deactivate
else
    python3 scripts/run_server.py > "$PROJECT_ROOT/site_readiness.log" 2>&1 &
    SITE_PID=$!
fi

# 4. Start Preventive Maintenance (Port 8000)
echo "[4/4] Starting Preventive Maintenance on http://localhost:8000 ..."
cd "$PROJECT_ROOT/preventive-maintenance"
python3 app.py > "$PROJECT_ROOT/pm.log" 2>&1 &
PM_PID=$!

cd "$PROJECT_ROOT"

echo "======================================================================"
echo "✅ All applications running with unified Python stack!"
echo "📍 Central Portal Hub: http://localhost:8080"
echo "   - 💬 AI Chatbot (df_rag_project):     http://localhost:5000"
echo "   - 📋 Site Readiness (Python):          http://localhost:3000"
echo "   - 🛠️ Preventive Maintenance:          http://localhost:8000"
echo ""
echo "To stop all services: ./stop_all.sh"
echo "======================================================================"

echo "$PORTAL_PID $RAG_PID $SITE_PID $PM_PID" > "$PROJECT_ROOT/.running_pids"
