# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

for file in ~/.bashrc.d/*.sh; do
  [ -r "$file" ] || continue
  source "$file"
done

[ -r ~/.bash_functions ] && source ~/.bash_functions
[ -r ~/.bash_aliases ] && source ~/.bash_aliases

