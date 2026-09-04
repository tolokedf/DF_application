@echo off
TITLE DF Application Suite - Stop All
echo ======================================================================
echo           🛑 Stopping all DF Application Suite services...
echo ======================================================================
echo.

echo Stopping Central Portal (Port 8080)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8080 ^| findstr LISTENING') do taskkill /f /pid %%a 2>nul

echo Stopping DF Chatbot (Port 5000)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :5000 ^| findstr LISTENING') do taskkill /f /pid %%a 2>nul

echo Stopping Site Readiness (Port 3000)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000 ^| findstr LISTENING') do taskkill /f /pid %%a 2>nul

echo Stopping Preventive Maintenance (Port 8000)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8000 ^| findstr LISTENING') do taskkill /f /pid %%a 2>nul

echo.
echo ======================================================================
echo ✅ All services stopped.
echo ======================================================================
pause
