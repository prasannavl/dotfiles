# make less more friendly for non-text input files, see lesspipe(1)

if [ ! -f "/etc/debian_version" ]; then return; fi

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
