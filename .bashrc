# ~/.bashrc: executed by bash(1) for non-login shells.
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

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    screen) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#	PS1='\u@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	
	# color prompt with git info (if any)
	PS1="${BWhite}\u@${BGreen}\h${BWhite} [${BBlue}\W${BWhite}]\$(get_git_info)\$(get_hg_info)\n\$ ${Color_Off}"
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#	PS1='\u@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	PS1="\u@\h [\W]\$(get_git_info)\$(get_hg_info)\$(get_hg_info)\n\$ "
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
		#PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		#PS1='\u@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
		PS1="${BWhite}\u@${BGreen}\h${BWhite} [${BBlue}\W${BWhite}]\$(get_git_info)\$(get_hg_info)\n\$ ${Color_Off}"
    ;;
*)
    ;;
esac

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

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

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

export EDITOR="emacsclient -c"

export PATH="$PATH:/sbin/"

# java
export JAVA_HOME="/opt/jdk/"
export ANT_HOME="/opt/apache-ant/"
export M2_HOME="/opt/apache-maven/"
export PATH="${PATH}:${JAVA_HOME}/bin/:${ANT_HOME}/bin/:${M2_HOME}/bin/"

# python
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_SCRIPT=/usr/share/virtualenvwrapper/virtualenvwrapper.sh
source /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh
