@echo off
TITLE DF Application Suite - GitHub Updater
COLOR 0B

echo ======================================================================
echo           🔄 DF Application Suite - GitHub Update Tool
echo ======================================================================
echo.

set ROOT_DIR=%~dp0
cd /d %ROOT_DIR%

echo [1/2] Pulling latest updates from root repository...
git pull origin main

echo.
echo [2/2] Updating all submodules to latest versions...
git submodule update --init --recursive

echo.
echo ======================================================================
echo ✅ All files and submodules are now up to date with GitHub!
echo ======================================================================
echo.
pause
