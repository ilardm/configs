# ~/.bashrc: executed by bash(0) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#
# .bashrc from OpenBSD
#
#
# color prompt
#

Color_Off='\[\033[0m\]'       # Text Reset

# Regular Colors
Black='\[\033[0;30m\]'        # Black
Red='\[\033[0;31m\]'          # Red
Green='\[\033[0;32m\]'        # Green
Yellow='\[\033[0;33m\]'       # Yellow
Blue='\[\033[0;34m\]'         # Blue
Purple='\[\033[0;35m\]'       # Purple
Cyan='\[\033[0;36m\]'         # Cyan
White='\[\033[0;37m\]'        # White

# Bold
BBlack='\[\033[1;30m\]'       # Black
BRed='\[\033[1;31m\]'         # Red
BGreen='\[\033[1;32m\]'       # Green
BYellow='\[\033[1;33m\]'      # Yellow
BBlue='\[\033[1;34m\]'        # Blue
BPurple='\[\033[1;35m\]'      # Purple
BCyan='\[\033[1;36m\]'        # Cyan
BWhite='\[\033[1;37m\]'       # White

# git integration
get_git_info()
{
	local GITINFO=$(git branch 2>/dev/null | grep -e ^* | sed 's/\*\ //')
	if [[ "$GITINFO" ]]; then
		echo -e " (git: $GITINFO-$(git log -n1 --pretty=format:%h 2>/dev/null))";
	fi;
}

gitarchive()
{
    DIR=$(basename $(pwd));
    git archive --prefix="${DIR}-${1}/" -o "../${DIR}-${1}.tar" "${1}";
}

get_hg_info()
{
	local HGINFO=$(hg branch 2>/dev/null)
	if [[ "$HGINFO" ]]; then
		echo -e " (hg: $HGINFO-$(hg identify -i 2>/dev/null))";
    fi;
}

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
PS1="\$? > ${BGreen}\u${Color_Off}@\h [\W]\$(get_git_info)\$(get_hg_info)\n\$ "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -F'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# custom values
export LESS="-R"

alias eclient='emacsclient -c'
alias xterm='xterm -bg black -fg gray'
alias hgk="hg view"
alias memleaks="valgrind --leak-check=full"
alias feh="feh -S filename -F -d"
alias bzip="pbzip -z9v"
alias bunzip="pbzip2 -dv"
alias mplayer="mplayer -zoom"
# alias mc="mc -b"
alias tmux="tmux -2"
alias gpg2="gpg"

export PATH="$PATH:/sbin/"
export EDITOR="nvim"
export PAGER="less"

# # i3-sensible-terminal
export TERMINAL='ghostty'

# export PATH="$PATH:/sbin/:/home/ilya/bin/android-sdk-linux/platform-tools/:/home/ilya/bin/node/bin"

# # java
# export JAVA_HOME="/opt/jdk/"
# export ANT_HOME="/opt/apache-ant/"
# export M2_HOME="/opt/apache-maven/"
# export PATH="${PATH}:${JAVA_HOME}/bin/:${ANT_HOME}/bin/:${M2_HOME}/bin/"

# python
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# go
export PATH="${PATH}:${HOME}/go/bin/"

# # flutter
export PATH="${PATH}:/home/ilya/bin/flutter/bin/"
export CHROME_EXECUTABLE="/usr/bin/chromium"

# pass
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_EXTENSIONS_DIR=$HOME/pass/password-store/.bin/ext/

# ssh agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

eval "$(direnv hook bash)"
