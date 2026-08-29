#!/bin/bash

LOCAL_DIR="$HOME/silvermine"
LOCAL_TRASH_DIR="$HOME/tmp/.per-gdrive-trash"
REMOTE_DIR="per-gdrive:Silvermine"
REMOTE_TRASH_DIR="per-gdrive:.mtv-per-gdrive-trash"
POLL_INTERVAL=60 # Seconds between checking remote changes

LOCK_FILE="/tmp/silvermine_rclone_bisync.lock"

# Trap SIGINT (Ctrl+C) and SIGTERM to kill all child processes
trap 'echo "Stopping sync..."; kill 0; exit' INT TERM EXIT

run_sync() {
  # # Check for internet connectivity
  # if ! ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
  #   return
  # fi

  # Fast, zero-network check: Abort immediately if Wi-Fi/Network is down
  if ! nc -zw1 8.8.8.8 53 >/dev/null 2>&1; then
    return
  fi

  # Execute sync using file locking to prevent parallel runs
  (
    flock -n 200 || exit 0
    rclone bisync "$LOCAL_DIR" "$REMOTE_DIR" \
      --conflict-resolve newer \
      --resilient \
      --force \
      --track-renames \
      --backup-dir1 "$LOCAL_TRASH_DIR" \
      --backup-dir2 "$REMOTE_TRASH_DIR" \
      --verbose
  ) 200>"$LOCK_FILE"
}

# 1. Background worker: Poll remote updates periodically
(
  while true; do
    sleep "$POLL_INTERVAL"
    run_sync
  done
) &

# 2. Main loop: Watch local directory using macOS FSEvents (fswatch)
# -l 1 batches rapidly consecutive events within 1 second into a single trigger
fswatch -o -l 1 --event Created --event Updated --event Removed --event Renamed "$LOCAL_DIR" | while read -r; do
  echo "==================== file updated"
  run_sync
done
