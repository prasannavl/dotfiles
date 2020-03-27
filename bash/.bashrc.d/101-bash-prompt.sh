# Bash Colors
# 
# Text Format           Foreground (text) color         Background color
# 0: normal text        30: Black                       40: Black
# 1: bold	            31: Red	                        41: Red
# 4: Underlined text    32: Green                       42: Green
#                       33: Yellow                      43: Yellow
#                       34: Blue                        44: Blue
#                       35: Purple                      45: Purple
#                       36: Cyan                        46: Cyan
#                       37: White                       47: White
# 
# ESC sequence: \033 or \e
# Color sequence: \[ESC[fg;format;bgm\] or \[$(tput setaf/ab color0-7)\] 
# tput => terminfo, ncurses

function setup_ps1() {
    # reset
    local r="\[$(tput sgr0)\]"
    local b="\[$(tput bold)\]"

    local fwhite="\[\033[38;5;15m\]"
    local fblack="\[\033[38;5;0m\]"
 
    local fgray="\[\033[38;5;7m\]"
    local fgreen="\[\033[38;5;2m\]"
    local fblue="\[\033[38;5;33m\]"
    local fred="\[\033[38;5;196m\]"
    local fpink="\[\033[38;5;13m\]"

    local error="${b}${fred}\$(e="\$?";[[ "\$e" == "0" ]] || printf \"[exit: "\$e"]\n\n\")"

    local ps1_main_line="${error}${r}${fgray}[\t|${b}${fgreen}\u${r}${fgreen}@\h\
${r}${fgray}:${r}${fblue}\w${r}${fgray}]"

    local ps1_exit_line="${r}\\n\$ "

    if [[ $(command -v git) ]]; then
        local ps1_main_line="${ps1_main_line} ${fpink}\`_parse_git_branch\`"
    fi

    export PS1="${ps1_main_line}${ps1_exit_line}"
}

# get current branch in git repo
function _parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`_parse_git_dirty`
		echo "(${BRANCH}${STAT})"
	else
		echo ""
	fi
}

# get current status of git repo
function _parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

setup_ps1