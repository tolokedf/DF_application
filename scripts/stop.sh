#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Stopping all DF Application services..."

if [ -f "$PROJECT_ROOT/logs/.running_pids" ]; then
    read -r P1 P2 P3 P4 < "$PROJECT_ROOT/logs/.running_pids"
    kill $P1 $P2 $P3 $P4 2>/dev/null
    rm -f "$PROJECT_ROOT/logs/.running_pids"
fi

if [ -f "$PROJECT_ROOT/.running_pids" ]; then
    read -r P1 P2 P3 P4 < "$PROJECT_ROOT/.running_pids"
    kill $P1 $P2 $P3 $P4 2>/dev/null
    rm -f "$PROJECT_ROOT/.running_pids"
fi

# Also kill by ports if lingering
for port in 8080 5000 3000 8000; do
    if command -v fuser >/dev/null 2>&1; then
        fuser -k ${port}/tcp 2>/dev/null
    elif command -v lsof >/dev/null 2>&1; then
        lsof -ti:${port} | xargs kill -9 2>/dev/null
    fi
done

echo "✅ All services stopped."
