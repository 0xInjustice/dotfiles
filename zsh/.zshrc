# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"


# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/omp.json)"

# Keybindings
bindkey -e
bindkey '^j' history-search-backward
bindkey '^k' history-search-forward
bindkey '^[w' kill-region
# Bind Ctrl + L to the right arrow key
bindkey '^h' vi-forward-char
bindkey '^n' vi-backward-char

# History
HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias c='clear'
alias x='exit'
alias std='shutdown now'
alias rbt='sudo reboot now'
alias tsx='tmux new -s'
alias tat="tmux attach -t"
alias tde='tmux detach -s'
alias tcl='tmux kill-server'
alias z='cd'
alias septy='ollama run septy'
alias update='sudo pacman -Syu &&  yay -Syu'
alias resolve='/opt/resolve/bin/resolve'
alias pacins='sudo pacman -S'

alias blestrt='sudo systemctl start bluetooth '
alias blestop='sudo systemctl stop bluetooth '

alias clearclip='rm ~/.cache/cliphist/db'

alias gst='git status'
alias gad='git add'
alias gcmt='git commit'
alias glg='git log'

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export PATH="$JAVA_HOME/bin:$PATH"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
export PATH=$PATH:$HOME/go/bin:/home/injustice/.pdtm/go/bin 
# Generated for pdtm. Do not edit.
export PATH=$PATH:$HOME/dotfiles/scripts



# Generated for pdtm. Do not edit.
export PATH=$PATH:/home/injustice/go

