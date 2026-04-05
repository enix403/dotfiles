#!/usr/bin/env bash

killall -q picom
sleep 1; # picom takes some time to quit
picom 2>&1 | tee -a /tmp/picom.log & disown