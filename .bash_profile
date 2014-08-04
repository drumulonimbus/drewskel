# Drew Smith ~/.bash_profile
# first checkin to github, 20140808

# make color things work
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'

# set the prompt, original and best version
export PS1="[\[\e[37;1m\]\u\[\e[0m\]@\[\e[37;1m\]\h\[\e[0m\]]\[\e[33;1m\] \w\[\e[0m\] $ "

# xterm title fixing stuff
export FQDN=`hostname -f`
export SHORTHOSTNAME=`hostname -s`
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${SHORTHOSTNAME}: ${PWD}\007"'

## this is for ssh hostname autocompletion
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


