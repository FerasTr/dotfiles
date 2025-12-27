# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

##################################
##           plugins            ##
##################################

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

zinit light zsh-users/zsh-syntax-highlightining
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# load completion
autoload -Uz compinit && compinit
zinit cdreplay -q

autoload -z edit-command-line
zle -N edit-command-line


##################################
##          vim mode            ##
##################################

bindkey -v
export KEYTIMEOUT=1
bindkey -M vicmd "^V" edit-command-line
bindkey "^R" history-incremental-search-backward

##################################
##    alias modern commands     ##
##################################

if which eza >/dev/null; then
    alias ls='eza --icons'
	# alias ls="exa --git-ignore"
	# alias ll="exa --git-ignore --git -l --group"
	# alias la="exa --git -la"
else
	alias ls="ls --color=always"
	# alias ll="ls -l"
	# alias la="ls -lA"
fi

if which bat >/dev/null; then
    alias cat='bat --paging=never'
fi

if which rg >/dev/null; then
    alias grep='rg --hidden --follow --glob "!.git"'
fi

if which fd >/dev/null; then
    alias grep='rg --hidden'
fi

# TODO: set sudoer editor to nvim as well
alias vi='nvim'
alias vim='nvim'
alias ni='nvim'
alias v='nvim'

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
## Environment Variables ##
###########################

DOTFILES_ROLES_DIR="$HOME/workspace/dotfiles/roles"


###############
## Functions ##
###############

addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

##################################
##         zsh options          ##
##################################

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ignore case when autocompleting
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# add color to tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# add color to tab completion
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
