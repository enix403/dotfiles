#!/bin/bash


pacman -Qeq | grep -Ev "perl|xorg|^lib|gtk|java|linux|plasma|poppler|texlive|python|qt5|virtualbox|systemd|ttf|xcb|xdg|xf86|cmake|ffmpeg"
