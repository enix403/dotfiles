#!/bin/bash
# journal_create.sh — create new empty daily text file if it doesn't exist

# --- Configuration ---
JOURNALS_ROOT="$HOME/kb/motive/journals" # default if not set

# --- Generate filename ---
DATE=$(date +%Y-%m-%d)
DAY=$(date +%a)
FILENAME="d-${DATE}-${DAY}.txt"
FILEPATH="${JOURNALS_ROOT}/${FILENAME}"

# --- Ensure directory exists ---
mkdir -p "$JOURNALS_ROOT"

# --- Create file if not exists ---
if [ ! -f "$FILEPATH" ]; then
  touch "$FILEPATH"
  echo "Created: $FILEPATH"
else
  echo "Already exists: $FILEPATH"
fi

exit 0
