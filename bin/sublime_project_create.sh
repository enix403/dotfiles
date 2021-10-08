#!/usr/bin/env sh

echo '{"folders": [{"path": "."}]}' | jq --indent 4 > "${1:-App}.sublime-project"
