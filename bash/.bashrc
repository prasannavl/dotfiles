# .bashrc

# Source global definitions on redhat based
# systems
if [[ -f /etc/bashrc ]]; then
	. /etc/bashrc
fi

# If not running interactively, quit so that
# we stay consistent on debian and redhat systems
case $- in
    *i*) ;;
      *) return;;
esac

# User specific aliases and functions

for file in ~/.bashrc.d/*.sh; do
  [[ -r "$file" ]] || continue
  source "$file"
done

[[ -r ~/.bash_functions ]] && source ~/.bash_functions
[[ -r ~/.bash_aliases ]] && source ~/.bash_aliases

