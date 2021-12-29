#!/usr/bin/env sh

exec startx "${@:2}" -- :"${1:-0}" vt"$XDG_VTNR"
