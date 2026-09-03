#!/usr/bin/env bash
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Stopping all DF Application services..."

if [ -f "$PROJECT_ROOT/.running_pids" ]; then
    read -r P1 P2 P3 P4 < "$PROJECT_ROOT/.running_pids"
    kill $P1 $P2 $P3 $P4 2>/dev/null
    rm -f "$PROJECT_ROOT/.running_pids"
fi

# Also kill by ports if lingering
fuser -k 8080/tcp 2>/dev/null
fuser -k 5000/tcp 2>/dev/null
fuser -k 3000/tcp 2>/dev/null
fuser -k 8000/tcp 2>/dev/null

echo "✅ All services stopped."
