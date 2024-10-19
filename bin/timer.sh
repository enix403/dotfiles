#!/usr/bin/env bash

# Default to 30 minutes if no argument is provided
duration=${1:-1800}

start="$(( $(date '+%s') + $duration ))"

while [ $start -ge $(date +%s) ]; do
  time="$(( $start - $(date +%s) ))"
  printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
  sleep 0.1
done

