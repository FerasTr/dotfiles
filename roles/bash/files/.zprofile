export XDG_CONFIG_HOME="$HOME/.config"
#export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
#export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"


export EDITOR="nvim"
export VISUAL="nvim"

# Add ~/.local/bin to $PATH
export PATH="$HOME/.local/bin:$PATH"
# Add ~/.local/bin/share to $PATH
export PATH="$HOME/.local/share/bin:$PATH"



export HISTFILE="$HOME/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file
export HISTDUP=erase
