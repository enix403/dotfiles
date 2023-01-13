#!/usr/bin/env sh

rand_name=$(tr -dc A-Z0-9 </dev/urandom | head -c 5)

echo '{"folders": [{"path": "."}]}' | jq --indent 4 > "${1:-SP_$rand_name}.sublime-project"
