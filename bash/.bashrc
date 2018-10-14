# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

for file in ~/.bashrc.d/*.sh; do
  [ -e "$file" ] || continue
  source "$file"
done

[ -f ~/.bash_functions ] && source ~/.bash_functions 
[ -f ~/.bash_aliases ] && source ~/.bash_aliases



