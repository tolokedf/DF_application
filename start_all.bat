@echo off
TITLE DF Application Suite - Master Launcher (Unified Python)
COLOR 0A

echo =====================================================================
echo       DF Application Suite - Master Launcher (Unified Python)
echo =====================================================================
echo.

set ROOT_DIR=%~dp0

:: 1. Start Portal (Port 8080)
start "DF Portal (Port 8080)" cmd /k "cd /d %ROOT_DIR%portal && python server.py"

:: 2. Start DF Chatbot (Port 5000)
start "DF Chatbot (Port 5000)" cmd /k "cd /d %ROOT_DIR%dfchatbot && python scripts\run_server.py"

:: 3. Start Site Readiness (Port 3000)
start "Site Readiness (Port 3000)" cmd /k "cd /d %ROOT_DIR%site-readiness && python scripts\run_server.py"

:: 4. Start Preventive Maintenance (Port 8000)
start "Preventive Maintenance (Port 8000)" cmd /k "cd /d %ROOT_DIR%preventive-maintenance && python scripts\run_server.py"

echo.
echo =====================================================================
echo [INFO] All services launched!
echo [INFO] Local Access:    http://localhost:8080
echo [INFO] Wi-Fi / Network: Open cmd and run "ipconfig" to find your IPv4 address,
echo        then devices on the same Wi-Fi can access: http://YOUR_IP:8080
echo =====================================================================
pause
