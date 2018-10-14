[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources

dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

exec i3


# Alternatively, 
#dbus-launch --exit-with-x11 i3
