#!/usr/bin/env bash

# org.gnome.mutter.wayland.keybindings
#     switch to ttys


# ❯ gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys
# # ....
# org.gnome.settings-daemon.plugins.media-keys help ['', '<Super>F1']
# org.gnome.settings-daemon.plugins.media-keys logout ['<Control><Alt>Delete']
# org.gnome.settings-daemon.plugins.media-keys magnifier ['<Alt><Super>8']
# org.gnome.settings-daemon.plugins.media-keys magnifier-zoom-in ['<Alt><Super>equal']
# org.gnome.settings-daemon.plugins.media-keys magnifier-zoom-out ['<Alt><Super>minus']
# org.gnome.settings-daemon.plugins.media-keys screenreader ['<Alt><Super>s']
# org.gnome.settings-daemon.plugins.media-keys screensaver ['<Super>l']
# # ....


gsettings set org.gnome.settings-daemon.plugins.media-keys magnifier "['']"
gsettings set org.gnome.settings-daemon.plugins.media-keys magnifier-zoom-in "['']"
gsettings set org.gnome.settings-daemon.plugins.media-keys magnifier-zoom-out "['']"
gsettings set org.gnome.settings-daemon.plugins.media-keys help "['']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screenreader "['']"

# Press Win+\ to lock
# The default Win+L is too close to Win+P, which I use quite a lot and accidently lock sometimes
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>Backslash']"



# ❯ gsettings list-recursively org.gnome.mutter
# org.gnome.mutter attach-modal-dialogs false
# org.gnome.mutter auto-maximize true
# org.gnome.mutter center-new-windows true
# org.gnome.mutter check-alive-timeout uint32 5000
# org.gnome.mutter draggable-border-width 10
# org.gnome.mutter dynamic-workspaces true
# org.gnome.mutter edge-tiling false
# org.gnome.mutter focus-change-on-pointer-rest false
# org.gnome.mutter locate-pointer-key 'Control_L'
# org.gnome.mutter overlay-key 'Super'
# org.gnome.mutter workspaces-only-on-primary false
# org.gnome.mutter.keybindings cancel-input-capture ['<Super><Shift>Escape']
# org.gnome.mutter.keybindings rotate-monitor ['XF86RotateWindows']
# org.gnome.mutter.keybindings switch-monitor ['<Super>m']
# org.gnome.mutter.keybindings toggle-tiled-left ['<Super>Left']
# org.gnome.mutter.keybindings toggle-tiled-right ['<Super>Right']

gsettings set org.gnome.mutter overlay-key ''
gsettings set org.gnome.mutter workspaces-only-on-primary true
gsettings set org.gnome.mutter.keybindings switch-monitor "['<Super>m']"


# ❯ gsettings list-recursively org.gnome.shell.keybindings
# org.gnome.shell.keybindings focus-active-notification ['<Super>n']
# org.gnome.shell.keybindings screen-brightness-cycle ['XF86MonBrightnessCycle']
# org.gnome.shell.keybindings screen-brightness-cycle-monitor ['<Shift>XF86MonBrightnessCycle']
# org.gnome.shell.keybindings screen-brightness-down ['XF86MonBrightnessDown']
# org.gnome.shell.keybindings screen-brightness-down-monitor ['<Shift>XF86MonBrightnessDown']
# org.gnome.shell.keybindings screen-brightness-up ['XF86MonBrightnessUp']
# org.gnome.shell.keybindings screen-brightness-up-monitor ['<Shift>XF86MonBrightnessUp']
# org.gnome.shell.keybindings screenshot ['<Shift>Print']
# org.gnome.shell.keybindings screenshot-window ['<Alt>Print']
# org.gnome.shell.keybindings show-screen-recording-ui ['<Ctrl><Shift><Alt>R']
# org.gnome.shell.keybindings show-screenshot-ui ['Print']
# org.gnome.shell.keybindings toggle-message-tray ['<Super>v', '<Super>m']

gsettings set org.gnome.shell.keybindings switch-to-application-1 '[]'
gsettings set org.gnome.shell.keybindings switch-to-application-2 '[]'
gsettings set org.gnome.shell.keybindings switch-to-application-3 '[]'
gsettings set org.gnome.shell.keybindings switch-to-application-4 '[]'
gsettings set org.gnome.shell.keybindings switch-to-application-5 '[]'
gsettings set org.gnome.shell.keybindings switch-to-application-6 '[]'
gsettings set org.gnome.shell.keybindings switch-to-application-7 '[]'
gsettings set org.gnome.shell.keybindings switch-to-application-8 '[]'
gsettings set org.gnome.shell.keybindings switch-to-application-9 '[]'

gsettings set org.gnome.shell.keybindings open-new-window-application-1 '[]'
gsettings set org.gnome.shell.keybindings open-new-window-application-2 '[]'
gsettings set org.gnome.shell.keybindings open-new-window-application-3 '[]'
gsettings set org.gnome.shell.keybindings open-new-window-application-4 '[]'
gsettings set org.gnome.shell.keybindings open-new-window-application-5 '[]'
gsettings set org.gnome.shell.keybindings open-new-window-application-6 '[]'
gsettings set org.gnome.shell.keybindings open-new-window-application-7 '[]'
gsettings set org.gnome.shell.keybindings open-new-window-application-8 '[]'
gsettings set org.gnome.shell.keybindings open-new-window-application-9 '[]'

gsettings set org.gnome.shell.keybindings shift-overview-down '[]'
gsettings set org.gnome.shell.keybindings shift-overview-up '[]'
gsettings set org.gnome.shell.keybindings toggle-message-tray '[]'
gsettings set org.gnome.shell.keybindings toggle-quick-settings '[]'

gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>p']"

# ❯ gsettings list-recursively org.gnome.desktop.wm.keybindings

# org.gnome.desktop.wm.keybindings activate-window-menu ['<Alt>space']
# org.gnome.desktop.wm.keybindings begin-move ['<Alt>F7']
# org.gnome.desktop.wm.keybindings begin-resize ['<Alt>F8']
# org.gnome.desktop.wm.keybindings close ['<Alt>F4']
# org.gnome.desktop.wm.keybindings cycle-group ['<Alt>F6']
# org.gnome.desktop.wm.keybindings cycle-group-backward ['<Shift><Alt>F6']
# org.gnome.desktop.wm.keybindings cycle-panels ['<Control><Alt>Escape']
# org.gnome.desktop.wm.keybindings cycle-panels-backward ['<Shift><Control><Alt>Escape']
# org.gnome.desktop.wm.keybindings cycle-windows ['<Alt>Escape']
# org.gnome.desktop.wm.keybindings cycle-windows-backward ['<Shift><Alt>Escape']
# org.gnome.desktop.wm.keybindings minimize ['<Super>h']
# org.gnome.desktop.wm.keybindings move-to-monitor-down ['<Super><Shift>Down']
# org.gnome.desktop.wm.keybindings move-to-monitor-left ['<Super><Shift>Left']
# org.gnome.desktop.wm.keybindings move-to-monitor-right ['<Super><Shift>Right']
# org.gnome.desktop.wm.keybindings move-to-monitor-up ['<Super><Shift>Up']
# org.gnome.desktop.wm.keybindings panel-run-dialog ['<Alt>F2']
# org.gnome.desktop.wm.keybindings switch-applications ['<Super>Tab', '<Alt>Tab']
# org.gnome.desktop.wm.keybindings switch-applications-backward ['<Shift><Super>Tab', '<Shift><Alt>Tab']
# org.gnome.desktop.wm.keybindings switch-group ['<Super>Above_Tab', '<Alt>Above_Tab']
# org.gnome.desktop.wm.keybindings switch-group-backward ['<Shift><Super>Above_Tab', '<Shift><Alt>Above_Tab']
# org.gnome.desktop.wm.keybindings switch-input-source ['<Super>space', 'XF86Keyboard']
# org.gnome.desktop.wm.keybindings switch-input-source-backward ['<Shift><Super>space', '<Shift>XF86Keyboard']
# org.gnome.desktop.wm.keybindings switch-panels ['<Control><Alt>Tab']
# org.gnome.desktop.wm.keybindings switch-panels-backward ['<Shift><Control><Alt>Tab']
# org.gnome.desktop.wm.keybindings toggle-maximized ['<Alt>F10']

gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 12

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>Above_Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>6']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>7']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>8']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>9']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-11 "['<Super>10']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-12 "['<Super>s']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-last "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "[]"

gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>Above_Tab']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>5']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>6']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>7']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>8']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>9']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-11 "['<Super><Shift>10']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-12 "['<Super><Shift>s']"

gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-last "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "[]"
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "[]"

gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']"

# =======================

# Add Kitty's bind = Win+Enter
CUSTOM_SCHEMA="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
CUSTOM_0="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"

gsettings set $CUSTOM_SCHEMA:$CUSTOM_0 name 'Launch Kitty'
gsettings set $CUSTOM_SCHEMA:$CUSTOM_0 command 'kitty'
gsettings set $CUSTOM_SCHEMA:$CUSTOM_0 binding '<Super>Return'
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$CUSTOM_0']"

# To remove keybind, use
# gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[]"
# gsettings reset-recursively $CUSTOM_SCHEMA:$CUSTOM_0
