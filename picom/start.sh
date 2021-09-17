#!/usr/bin/env bash

killall picom
picom 2>&1 | tee -a /tmp/picom.log & disown