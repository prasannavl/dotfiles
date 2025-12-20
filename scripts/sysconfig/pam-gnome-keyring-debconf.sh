#!/usr/bin/env bash

cat <<END | sudo tee /usr/share/pam-configs/gnome-keyring-local
Name: GNOME Keyring Local
Default: yes
Priority: 0
Auth-Type: Additional
Auth:
    optional pam_gnome_keyring.so

Password-Type: Additional
Password:
    optional pam_gnome_keyring.so use_authtok

Session-Type: Additional
Session-Interactive-Only: yes
Session:
    optional pam_gnome_keyring.so auto_start

END

sudo pam-auth-update --package gnome-keyring-local