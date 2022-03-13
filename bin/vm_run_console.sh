#!/usr/bin/env sh

exec /usr/bin/xterm -bg teal -maximized -e block_command.sh VBoxManage startvm "${@}";

