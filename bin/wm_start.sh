#!/usr/bin/env sh

exec startx -- :"${1:-0}" vt"$XDG_VTNR"
