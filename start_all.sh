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
setsid nohup python3 -u "$PROJECT_ROOT/portal/server.py" > "$PROJECT_ROOT/portal.log" 2>&1 &
PORTAL_PID=$!

# 2. Start DF Chatbot (Port 5000)
echo "[2/4] Starting DF AI Chatbot on http://localhost:5000 ..."
cd "$PROJECT_ROOT/dfchatbot"
if [ -f ".venv/bin/python" ]; then
    setsid nohup .venv/bin/python -u scripts/run_server.py > "$PROJECT_ROOT/dfchatbot.log" 2>&1 &
    RAG_PID=$!
else
    setsid nohup python3 -u scripts/run_server.py > "$PROJECT_ROOT/dfchatbot.log" 2>&1 &
    RAG_PID=$!
fi

# 3. Start Site Readiness (Port 3000) - Python Flask
echo "[3/4] Starting Site Readiness (Python) on http://localhost:3000 ..."
cd "$PROJECT_ROOT/site-readiness"
if [ -f ".venv/bin/python" ]; then
    setsid nohup .venv/bin/python -u scripts/run_server.py > "$PROJECT_ROOT/site_readiness.log" 2>&1 &
    SITE_PID=$!
else
    setsid nohup python3 -u scripts/run_server.py > "$PROJECT_ROOT/site_readiness.log" 2>&1 &
    SITE_PID=$!
fi

# 4. Start Preventive Maintenance (Port 8000)
echo "[4/4] Starting Preventive Maintenance on http://localhost:8000 ..."
cd "$PROJECT_ROOT/preventive-maintenance"
if [ -f ".venv/bin/python" ]; then
    setsid nohup .venv/bin/python -u scripts/run_server.py > "$PROJECT_ROOT/pm.log" 2>&1 &
    PM_PID=$!
else
    setsid nohup python3 -u scripts/run_server.py > "$PROJECT_ROOT/pm.log" 2>&1 &
    PM_PID=$!
fi

cd "$PROJECT_ROOT"

# Detect Local Wi-Fi / LAN IP Address
LOCAL_IP=$(python3 -c "
import socket
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
try:
    s.connect(('8.8.8.8', 80))
    ip = s.getsockname()[0]
except Exception:
    ip = '127.0.0.1'
finally:
    s.close()
print(ip)
")

echo "======================================================================"
echo "✅ All applications running with unified Python stack!"
echo "📍 Local Access:   http://localhost:8080"
echo "🌐 Wi-Fi / LAN:    http://${LOCAL_IP}:8080 (Share with devices on same Wi-Fi)"
echo ""
echo "   - 💬 AI Chatbot (dfchatbot):           http://${LOCAL_IP}:5000"
echo "   - 📋 Site Readiness (Python):          http://${LOCAL_IP}:3000"
echo "   - 🛠️ Preventive Maintenance:          http://${LOCAL_IP}:8000"
echo ""
echo "To stop all services: ./stop_all.sh"
echo "======================================================================"

disown -a 2>/dev/null
echo "$PORTAL_PID $RAG_PID $SITE_PID $PM_PID" > "$PROJECT_ROOT/.running_pids"
