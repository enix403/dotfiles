#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xset s 3600
xset dpms 0 0 3600

numlockx

case $WM in
kde)
	export DESKTOP_SESSION=plasma
	exec startplasma-x11
	;;
i3)
	exec i3
	;;
cin)
	export XDG_CURRENT_DESKTOP=Cinnamon
	export DESKTOP_SESSION=cinnamon
	exec cinnamon-session
	;;
xm)
	exec xmonad
	;;
*)
	exec i3
    ;;
esac
