#!/usr/bin/env bash

# UI

# Disable hot corner (mouse moving to top-left corner shows overview of all windows)
gsettings set org.gnome.desktop.interface enable-hot-corners false

# -------------

# Display

# Disable the abrupt "pre-dimming" of screen after 30 seconds. This delay
# of 30 seconds is actually *hardcoded* in gnome. No way to change that
# Note: on power saver mode, this is always enabled without any way to
# turn if off
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 100

# After 240 seconds of screen inactivity, consider the system as idle. After this
# period it starts a transition of screen dimming towards pure black of exactly 10
# seconds (hardcoded). So after 240 + 10 = 250 seconds the screen is turned off
gsettings set org.gnome.desktop.session idle-delay 240

# After system is idle (after idle-delay), lock the screen after additional
# 60 seconds. So screen is locked after 240 + 60 = 300 seconds
gsettings set org.gnome.desktop.screensaver idle-activation-enabled true
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.screensaver lock-delay "uint32 60"

# disable auto-brightness based on surrounding lights (if sensor is available)
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

# ----------

# Sleeping/Suspending

# Never suspend at all
# Note that the above idle-* settings are only for the display. These sleep-*
# are for the wider system
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

# Don't do anything on power button press
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'nothing'

# Never go into power saver mode
gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery false

