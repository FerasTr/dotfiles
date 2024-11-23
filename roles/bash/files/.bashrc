# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

###########
## Color ##
###########

# Normal Bash
export PS1='\[\e[1;38;5;244m\]\t \[\e[1;36m\]\u@\H \[\e[1;33m\]\w \[\e[1;36m\]\$ \[\e[0m\]'

# Termux (without user@host)
# export PS1='\[\e[1;38;5;244m\]\t \[\e[1;33m\]\w \[\e[1;36m\]\$ \[\e[0m\]'

# Minimal without path to working directory (~ $)
# export PS1='\[\e[1;33m\]\W \[\e[1;36m\]\$ \[\e[0m\]'

##################################
## ls, exa & more colored stuff ##
##################################

if which exa >/dev/null; then
	# exa is a modern ls replacement with Git integration: https://the.exa.website
	alias ls="exa --git-ignore"
	alias ll="exa --git-ignore --git -l --group"
	alias la="exa --git -la"
else
	alias ls="ls --color=always"
	alias ll="ls -l"
	alias la="ls -lA"
fi
for alias in lsl sls lsls sl l s; do alias $alias=ls; done

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

########################################
## Cool bash features nobody knows of ##
########################################

# search through history with up/down arrows
bind '"\e[A": history-search-backward' 2>/dev/null
bind '"\e[B": history-search-forward' 2>/dev/null

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

#############################
## Warn about root shells! ##
#############################

if [ `id -u` -eq 0 ]; then
    start="\033[1;37;41m"
    end="\033[0m"
    printf "\n"
    printf "  $start                                                                       $end\n"
    printf "  $start  WARNING: You are in a root shell. This is probably a very bad idea.  $end\n"
    printf "  $start                                                                       $end\n"
    printf "\n"
fi

#########################
## Path & Applications ##
#########################

# Setup GOPATH
# export GOPATH="$HOME/.local/lib/go"
# export PATH="$GOPATH/bin:$PATH"

# Setup npm global installs without sudo
# export NPMPATH="$HOME/.local/lib/npm"
# export PATH="$NPMPATH/bin:$PATH"
# [ -f ~/.npmrc ] || ! which npm >/dev/null || echo "prefix=$NPMPATH" > ~/.npmrc

# Add ~/.local/bin to $PATH
export PATH="$HOME/.local/bin:$PATH"
# Add ~/.local/bin/share to $PATH
export PATH="$HOME/.local/share/bin:$PATH"

#############################
## Awesome online services ##
#############################

# TODO

###########################
## Other helpful aliases ##
###########################

# If ag is not installed, alias it to "grep -rn" (and generally force color for grep)
# alias grep="grep --color=always"
# which ag >/dev/null || alias ag="grep -rn"

# Provide a yq command to use jq with YAML files
alias yq="python3 -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' | jq"

# A really simple password generator
# alias pw='bash -c '"'"'echo `tr -dc $([ $# -gt 1 ] && echo $2 || echo "A-Za-z0-9") < /dev/urandom | head -c $([ $# -gt 0 ] && echo $1 || echo 30)`'"'"' --'

###########################
## distro-specific stuff ##
###########################

# TODO

##################
## Custom stuff ##
##################

# TODO
