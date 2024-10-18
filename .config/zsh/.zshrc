#!/bin/sh
export ZDOTDIR=$HOME/.config/zsh

echo '\e[5 q'

# Useful Functions
source "$ZDOTDIR/zsh-functions"
# source "$ZDOTDIR/fzf-git.sh"

zsh_add_file "zsh-exports"
zsh_add_file "zsh-aliases"

# Цвет автодополнения
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'


plugins=(
    fzf
    fzf-tab
    # git
    # tmux
    sudo
    # diff-so-fancy
    web-search
    zsh-navigation-tools
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-fzf-history-search
    z
)

ZSH_TMUX_CONFIG=~/.config/tmux/tmux.conf
# ZSH_TMUX_AUTOSTART=true
# ZSH_TMUX_AUTOCONNECT=true
ZSH_TMUX_AUTOQUIT=true
ZSH_TMUX_FIXTERM=true
# FZF_TMUX_HEIGHT=100


# bindkey -s '^o' 'lf^M'
bindkey -s '^z' '^u'
bindkey -s '^n' 'ncmpcpp^M'
bindkey -s '^o' 'y^M'

source $ZSH/oh-my-zsh.sh



autoload bashcompinit
bashcompinit

####################################
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup


# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:*' fzf-preview '
if file --mime-type $realpath | grep -qF directory; then
    exa -1 --color=always --icons --all $realpath
elif file --mime-type $realpath | grep -qF image/; then
    chafa $realpath
else
    batcat --style=numbers --color=always $realpath || mediainfo $realpath 2>/dev/null
fi
'

# apply to all command
zstyle ':fzf-tab:*' popup-min-size 190 80

# zstyle ':fzf-tab:complete:*' fzf-preview 'lsd $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1a --color=always --icons $realpath'

# only apply to 'diff'
zstyle ':fzf-tab:complete:diff:*' popup-min-size 80 12

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '- %d'

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
####################################

_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
        z)            fzf "$@" --preview 'tree -C {} | head -200' ;;
        *)            fzf "$@" ;;
    esac
}

compdef _note note


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/14.toml)"
