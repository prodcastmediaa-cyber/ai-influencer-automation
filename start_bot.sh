#!/bin/bash
# Start the AI Influencer bot (single-instance, safe to run repeatedly)
cd "$(dirname "$0")"

PID_FILE=".watcher.pid"

# Kill any existing instance via PID file
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Stopping existing bot (PID $OLD_PID)..."
        kill "$OLD_PID"
        sleep 3
        kill -9 "$OLD_PID" 2>/dev/null || true
    fi
    rm -f "$PID_FILE"
fi

# Belt-and-suspenders: kill any stray watcher.py processes
pkill -9 -f "python3.*watcher\.py" 2>/dev/null || true
sleep 1

# Start fresh — stdout to /dev/null because FileHandler owns watcher.log
nohup python3 watcher.py > /dev/null 2>&1 &
echo "Bot started (PID $!)"
