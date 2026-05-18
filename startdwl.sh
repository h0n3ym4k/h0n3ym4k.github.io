#VBoxClient --clipboard &
export XDG_RUNTIME_DIR=/tmp/xdg-runtime-$(id -u)
mkdir -p $XDG_RUNTIME_DIR
#/root/X11/dwl

for portal in xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal
do
	pkill -e "$portal"
done

/usr/libexec/xdg-desktop-portal-wlr &
/usr/libexec/xdg-desktop-portal-gtk &

sleep 1

/usr/libexec/xdg-desktop-portal &

export XDG_CURRENT_DESKTOP=wlroots
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=wlroots

XDG_SEAT=seat0
XDG_SESSION_DESKTOP=wlroots
XDG_SESSION_TYPE=wayland
XDG_CURRENT_DESKTOP=wlroots
XDG_SESSION_CLASS=user
XDG_VTNR=1
XDG_SESSION_ID=1
#XDG_RUNTIME_DIR=
#DBUS_SESSION_BUS_ADDRESS=unix:path=

dbus-run-session dwl -s /root/X11/startdwl.sh.start
