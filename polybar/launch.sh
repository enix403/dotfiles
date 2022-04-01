#!/usr/bin/env bash

# killall -q polybar

# while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# echo "---" | tee -a /tmp/polybar.log
# polybar main 2>&1 | tee -a /tmp/polybar.log & disown

# Terminate already running bar instances
killall -q polybar

# # Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# # Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar main --config="$HOME/.config/polybar/config.ini" & disown

# ----------------------


# Terminate already running bar instances
# killall -q polybar

# # Wait until the processes have been shut down
# while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# # Launch Polybar, using default config location ~/.config/polybar/config.ini
# polybar main --config="$HOME/.config/polybar/polybar-rounded/config.ini" &

# echo "Polybar launched..."