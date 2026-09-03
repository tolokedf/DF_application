#!/bin/bash
# DF Application Suite - 1-Click Database Export to USB / Zip
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/scripts/export_database.py" "$@"
