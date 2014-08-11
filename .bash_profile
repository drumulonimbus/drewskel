# Drew Smith ~/.bash_profile
# first checkin to github, 20140808
# update 20140811, add a bunch of new bits

# make color things work
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'

## stuff stolen from Ubuntu .bash_profile:
#############################
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
##############################


# Determine which prompt to use:
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have colour support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        colour_prompt=yes
else
        colour_prompt=
fi

# bash prompt 
if [[ "$colour_prompt" = "yes" ]]; then
	# colour prompt
	export PS1="[\[\e[37;1m\]\u\[\e[0m\]@\[\e[37;1m\]\h\[\e[0m\]]\[\e[33;1m\] \w\[\e[0m\] $ "
	export PS2="\e[37;1m>\e[0m "
else
	export PS1="[\u@\h] \w $"
	export PS2="> "
fi

# fix xterm title bar
case "$TERM" in
	xterm*|rxvt*)
		export FQDN=$(hostname -f)
		export SHORTHOSTNAME=$(hostname -s)
		export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${SHORTHOSTNAME}: ${PWD}\007"'
		;;
	*)
		;;
esac

# ssh hostname autocompletion
_complete_hosts () {
	COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        host_list=`{ 
                for c in /etc/ssh_config /etc/ssh/ssh_config ~/.ssh/config
                do [ -r $c ] && sed -n -e 's/^Host[[:space:]]//p' -e 's/^[[:space:]]*HostName[[:space:]]//p' $c
		done
		for k in /etc/ssh_known_hosts /etc/ssh/ssh_known_hosts ~/.ssh/known_hosts
		do [ -r $k ] && egrep -v '^[#\[]' $k|cut -f 1 -d ' '|sed -e 's/[,:].*//g'
		done
		sed -n -e 's/^[0-9][0-9\.]*//p' /etc/hosts; }|tr ' ' '\n'|grep -v '*'`
	COMPREPLY=( $(compgen -W "${host_list}" -- $cur))
	return 0
}
complete -F _complete_hosts ssh
complete -F _complete_hosts host


