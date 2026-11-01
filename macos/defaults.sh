#!/usr/bin/env bash
# macOS System Settings as code. Safe to re-run; only touches the keys below.
# Written against macOS 26 (Tahoe). Apple renames keys between releases, so a
# failed write only warns. Some changes need a logout to fully apply.
#
# To find the key behind a toggle: `defaults-diff snap`, flip it in System
# Settings, then `defaults-diff`.
set -uo pipefail

[ "$(uname -s)" = Darwin ] || { echo "defaults.sh: not macOS" >&2; exit 1; }
major=$(sw_vers -productVersion | cut -d. -f1)
[ "$major" = 26 ] || echo "warning: written for macOS 26, this is $(sw_vers -productVersion)" >&2

failed=0
w() { defaults write "$@" || { echo "warning: failed: defaults write $*" >&2; failed=1; }; }

# Quit System Settings so it doesn't overwrite what we write
osascript -e 'tell application "System Settings" to quit' 2>/dev/null

# ---- Appearance
w NSGlobalDomain AppleInterfaceStyle -string Dark
w NSGlobalDomain AppleAccentColor -int 0                                  # red
w NSGlobalDomain AppleHighlightColor -string "1.000000 0.749020 0.823529 Pink"
w NSGlobalDomain NSGlassDiffusionSetting -int 1                           # Liquid Glass: tinted
w NSGlobalDomain AppleScrollerPagingBehavior -int 1                       # click in scroll bar jumps to the spot

# ---- Windows
w NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false           # no open/close zoom animation
w NSGlobalDomain AppleWindowTabbingMode -string manual                    # prefer tabs: never
w NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false
w NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true                  # ask to keep changes when closing documents

# ---- Desktop & Dock
w com.apple.dock autohide -bool true
w com.apple.dock autohide-delay -float 0                                  # show immediately on hover
w com.apple.dock autohide-time-modifier -float 0.2                        # fast slide animation
w com.apple.dock tilesize -int 44
w com.apple.dock show-recents -bool false
w com.apple.dock mru-spaces -bool false                                   # don't reorder Spaces by use
w com.apple.dock expose-group-apps -bool true                             # Mission Control groups windows by app (AeroSpace)
w com.apple.dock wvous-br-corner -int 1                                   # bottom-right hot corner: none
w com.apple.dock wvous-br-modifier -int 0
w com.apple.WindowManager EnableStandardClickToShowDesktop -bool false    # clicking wallpaper doesn't reveal desktop
w com.apple.WindowManager HideDesktop -bool true                          # Stage Manager: hide desktop items
w com.apple.WindowManager AppWindowGroupingBehavior -int 1                # Stage Manager: one window at a time

# Pinned Dock apps, in order. Apps that aren't installed are skipped.
DOCK_APPS=(
    "/Applications/Google Chrome.app"
    "/Applications/kitty.app"
    "/Applications/Slack.app"
    "/Applications/Visual Studio Code.app"
    "/System/Applications/System Settings.app"
    "/Applications/Cursor.app"
    "/System/Applications/Apps.app"
    "/System/Applications/Preview.app"
    "/Applications/Firefox.app"
)
w com.apple.dock persistent-apps -array
for app in "${DOCK_APPS[@]}"; do
    [ -d "$app" ] || { echo "dock: skip missing $app"; continue; }
    url="file://${app// /%20}/"
    w com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$url</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>"
done

# ---- Menu bar clock
w com.apple.menuextra.clock IsAnalog -bool true
w com.apple.menuextra.clock ShowDate -int 1                               # always
w com.apple.menuextra.clock ShowDayOfWeek -bool false
w com.apple.menuextra.clock ShowAMPM -bool true
w com.apple.menuextra.clock ShowSeconds -bool false

# ---- Keyboard
w NSGlobalDomain KeyRepeat -int 2
w NSGlobalDomain InitialKeyRepeat -int 15
w NSGlobalDomain ApplePressAndHoldEnabled -bool false                     # key repeat instead of the accent popup

# ---- Keyboard shortcuts (System Settings > Keyboard > Keyboard Shortcuts)
# hotkey <id> <true|false> <ascii> <keycode> <modifiers>
# Modifier bits: shift 131072, ctrl 262144, opt 524288, cmd 1048576, fn 8388608.
# 65535 means "no key".
hotkey() {
    w com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
        "<dict><key>enabled</key><$2/><key>value</key><dict><key>parameters</key><array><integer>$3</integer><integer>$4</integer><integer>$5</integer></array><key>type</key><string>standard</string></dict></dict>"
}
# Off: they collide with AeroSpace/Karabiner bindings or are never used
hotkey 32  false 65535 126 8650752   # Mission Control (ctrl-up)
hotkey 33  false 65535 125 8650752   # Application windows (ctrl-down)
hotkey 60  false 32 49 262144        # Previous input source (ctrl-space)
hotkey 61  false 32 49 786432        # Next input source (ctrl-opt-space)
hotkey 64  false 32 49 1048576       # Spotlight (cmd-space)
hotkey 65  false 32 49 1572864       # Finder search window (opt-cmd-space)
hotkey 98  false 47 44 1179648       # Show Help menu (shift-cmd-/)
hotkey 59  false 65535 96 9437184    # VoiceOver (cmd-F5)
hotkey 162 false 65535 96 9961472    # Accessibility controls (opt-cmd-F5)
hotkey 21  false 56 28 1835008       # Invert colors (ctrl-opt-cmd-8)
hotkey 25  false 46 47 1835008       # Increase contrast (ctrl-opt-cmd-.)
hotkey 26  false 44 43 1835008       # Decrease contrast (ctrl-opt-cmd-,)
hotkey 233 false 109 46 1048576      # (cmd-m variant added in macOS 26)
for id in 164 215 216 217 218 219 225 226 227 228 229 230 231 232; do
    hotkey "$id" false 65535 65535 0 # unbound entries, kept off
done
# On: Accessibility zoom
hotkey 15  true 56 28 1572864        # Zoom on/off (opt-cmd-8)
hotkey 17  true 61 24 1572864        # Zoom in (opt-cmd-=)
hotkey 19  true 45 27 1572864        # Zoom out (opt-cmd--)
hotkey 23  true 92 65535 1572864     # Smooth images (opt-cmd-\)

# ---- Trackpad & mouse
# Built-in and Bluetooth trackpads read separate domains; the login screen
# reads -currentHost.
for d in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
    w "$d" Clicking -bool true                                            # tap to click
    w "$d" TrackpadThreeFingerDrag -bool false
done
w -currentHost NSGlobalDomain com.apple.mouse.tapBehavior -int 1
w NSGlobalDomain com.apple.trackpad.scaling -float 0.6875                 # tracking speed
w NSGlobalDomain com.apple.mouse.scaling -float 1.5

# ---- Finder
w NSGlobalDomain AppleShowAllExtensions -bool true
w com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
w com.apple.finder ShowRemovableMediaOnDesktop -bool true
w com.apple.finder ShowHardDrivesOnDesktop -bool false

# ---- Language & Region
w NSGlobalDomain AppleFirstWeekday -dict gregorian -int 2                 # week starts on Monday

# ---- Accessibility (writes need Full Disk Access for the terminal)
w com.apple.universalaccess closeViewHotkeysEnabled -bool true            # zoom with keyboard shortcuts
w com.apple.universalaccess stereoAsMono -bool true                       # mono audio

# ---- Apply
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null
killall Dock Finder SystemUIServer cfprefsd 2>/dev/null

[ $failed = 0 ] && echo "Done. Log out and back in for keyboard and trackpad changes." \
    || { echo "Done with warnings (see above)." >&2; exit 1; }
