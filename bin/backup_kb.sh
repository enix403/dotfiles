#!/bin/bash
# backup_kb.sh — creates a dated tar.gz backup and retains only last 15

# --- Configuration ---
SOURCE_DIR="$HOME/kb"           # Folder you want to back up
BACKUP_DIR="$HOME/MyBackups/kb" # Destination for backups
DATE=$(date +%Y-%m-%d-%H-%M-%S)
FILENAME="kb-$DATE.tar.gz"

# --- Create backup directory if missing ---
mkdir -p "$BACKUP_DIR"

# --- Create the backup ---
tar -czf "$BACKUP_DIR/$FILENAME" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# --- Keep only last 20 backups ---
cd "$BACKUP_DIR" || exit
# ls -tp kb-*.tar.gz | grep -v '/$' | tail -n +16 | xargs -r rm --
# ls -1v kb-*.tar.gz | head -n -15 | xargs -r rm --
COUNT=$(ls -1v kb-*.tar.gz 2>/dev/null | wc -l)
if [ "$COUNT" -gt 20 ]; then
  ls -1v kb-*.tar.gz | head -n $((COUNT - 20)) | xargs -r rm --
fi

exit 0
