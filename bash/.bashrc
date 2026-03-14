export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export DOTFILES_DIR="$HOME/personal/dotfiles"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

alias vim="nvim"
alias htop="btop"
alias cp="cp -ivr"
alias rm="rm -r"
alias ls="ls -AhFv --color=auto --group-directories-first"
alias ll="ls -lahFv --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias ln="ln -v"
alias mkdir="mkdir -vp"
alias free="free -h"
alias mv="mv -iv"
alias du="du -h"

upgrade() {
    sudo apt update && sudo apt upgrade
    flatpak update
    mise upgrade
    pipx upgrade-all
}

autoremove() {
    sudo apt autoremove --purge
    flatpak remove --unused
    mise prune
}

backup_notes() {
    cd "$HOME/personal/notes"
    git pull
    git add .
    git commit -m "notes backup: $(date --rfc-3339 s)"
    git push
    cd -
}
