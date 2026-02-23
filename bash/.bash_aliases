alias vim="nvim"
alias htop="btop"
alias cp="cp -ivr"
alias rm='rm -vr'
alias ls='ls -AhFv --color=auto --group-directories-first'
alias ll='ls -lahFv --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias ln='ln -v'

upgrade() {
    sudo apt update && sudo apt -y upgrade
    flatpak update
    mise upgrade
    pipx upgrade-all
}

autoremove() {
    sudo apt autoremove -y --purge
    flatpak remove --unused
    mise prune
}

backup_notes() {
    git pull
    git commit -am "notes backup: $(date --rfc-3339 s)"
    git push
}
