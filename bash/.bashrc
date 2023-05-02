# .bashrc

# Source global definitions on redhat based systems
if [[ -f /etc/bashrc ]]; then
    . /etc/bashrc
fi
# On Debian/Ubuntu: /etc/bash.bashrc copied to user and overriden
# instead of chaining.
#   default = Skip entirely on non-interactive
#   non-interactive = setopts, setup chroot ps1, cmd not found
# So we don't do anything.

# If not running interactively, quit so that
# we stay true to debian and redhat defaults
case $- in
*i*) ;;
*) return ;;
esac

# User interactive session begins

for file in ~/.bashrc.d/*.sh; do
    [[ -r "$file" ]] || continue
    source "$file"
done

