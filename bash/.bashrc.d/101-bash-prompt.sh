r="\[$(tput sgr0)\]"
b="\[$(tput bold)\]"

fwhite="\[\033[38;5;15m\]"
fblack="\[\033[38;5;0m\]"

fgray="\[\033[38;5;7m\]"
fgreen="\[\033[38;5;2m\]"
fblue="\[\033[38;5;33m\]"
fred="\[\033[38;5;196m\]"

# date="\D{%Y-%m-%d}"
error="${b}${fred}\$(e="\$?";[[ "\$e" == "0" ]] || echo [exit: "\$e"])"

export PS1="${fgray}[\t|${b}${fgreen}\u${r}${fgreen}@\h\
${r}${fgray}:${r}${fblue}\w${r}${fgray}] \
${error}${r}\\n\$ "

unset r b fwhite fblack fgray fgreen fblue fred error


# bdir="\[\033[48;5;237m\]"
# fdir="\[\033[38;5;252m\]"

# ftime="\[\033[38;5;250m\]"
# btime="\[\033[48;5;240m\]"

# berr="\[\033[48;5;1m\]"
# ferr="\[\033[38;5;255m\]"

# fdark="\[\033[38;5;241m\]"

# error="${ferr}${berr}\$(e="\$?";[[ "\$e" == "0" ]] || echo \ \ exit: "\$e"\ \ )"

# export PS1="${ftime}${btime}  \t  ${r}${fdir}${bdir}  \u@\h  \
# ${fdark}│${b}${fgreen}  \w  ${r}\
# ${error}${r}\\n\$ "

# unset bdir fdir ftime btime berr ferr fdark error
