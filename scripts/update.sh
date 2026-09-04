#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "======================================================================"
echo "          🔄 DF Application Suite - GitHub Update Tool"
echo "======================================================================"
echo ""

cd "$PROJECT_ROOT"

echo "[1/2] Pulling latest updates from root repository..."
git pull origin main

echo ""
echo "[2/2] Updating all submodules to latest versions..."
git submodule update --init --recursive

echo ""
echo "======================================================================"
echo "✅ All files and submodules are now up to date with GitHub!"
echo "======================================================================"
