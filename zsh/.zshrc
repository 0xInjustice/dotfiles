ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

zinit ice lucid wait
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

eval "$(zoxide init --cmd cd zsh)"

zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color=auto $realpath'

if [[ ! -f ~/.zcompdump ]]; then
    autoload -Uz compinit && compinit
else
    autoload -Uz compinit && compinit -C
fi

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' %F{yellow}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}%b|%a%f'

git_signs() {
    [[ -d .git ]] || return ''
    local unstaged staged
    git diff --quiet --ignore-submodules HEAD 2>/dev/null || unstaged=1
    git diff --cached --quiet --ignore-submodules HEAD 2>/dev/null || staged=1

    if [[ $staged && $unstaged ]]; then
        echo "%F{red}✗%f"
    elif [[ $unstaged ]]; then
        echo "%F{yellow}~%f"
    elif [[ $staged ]]; then
        echo "%F{green}+%f"
    else
        echo "%F{white}✔%f"
    fi
}

precmd() { vcs_info }

setopt prompt_subst

WHITE='%F{white}'
RED='%F{red}'
BLUE='%F{blue}'

if [[ $EUID -eq 0 ]]; then
    USER_COLOR=$RED
    PROMPT_CHAR="-#"
else
    USER_COLOR=$WHITE
    PROMPT_CHAR="-$"
fi

PS1='%{%B%}'$USER_COLOR'%{%}${USER}%{%b%}%{%F{red}%}%B@%m%b%{%f%}:'\
'%{%F{blue}%}%B%~%b%{%f%}${vcs_info_msg_0_}$(git_signs)'"$PROMPT_CHAR"' '

HISTFILE=$HOME/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt append_history inc_append_history hist_ignore_dups hist_ignore_space hist_reduce_blanks extended_history

bindkey -e
bindkey '^j' history-search-backward
bindkey '^k' history-search-forward
bindkey '^[w' kill-region
bindkey '^h' vi-forward-char
bindkey '^n' vi-backward-char

alias ls='ls --color'
alias mv='mv -v'
alias cp='cp -v'
alias mkdir='mkdir -v'
alias c='clear'
alias x='exit'
alias std='shutdown now'
alias rbt='sudo reboot now'
alias tsx='tmux new -s'
alias tat="tmux attach -t"
alias tde='tmux detach -s'
alias tcl='tmux kill-server'
alias z='zoxide'
alias septy='ollama run septy'
alias update='sudo pacman -Syu && yay -Syu'
alias resolve='/opt/resolve/bin/resolve'
alias pacins='sudo pacman -S'
alias refl='sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --download-timeout 20 --country India --connection-timeout 25'
alias blestrt='sudo systemctl start bluetooth'
alias blestop='sudo systemctl stop bluetooth'
alias clearclip='rm ~/.cache/cliphist/db'
alias gst='git status'
alias gad='git add'
alias gcmt='git commit'
alias glg='git log'

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$PATH:$HOME/dotfiles/scripts"
export PATH="$PATH:/home/injustice/go"

zinit cdreplay -q
