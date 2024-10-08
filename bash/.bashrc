# .bashrc

# Source global definitions on redhat based systems
# Debian calls these /etc/bash.bashrc, so won't source it.
# On Debian /etc/bash.bashrc copied to user and overriden
# instead of chaining. So we don't do anything.
if [[ -f /etc/bashrc ]]; then
    . /etc/bashrc
fi

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

