alias vim="nvim"
alias htop="btop"
alias cp="cp -ivr"
alias rm="rm -r"
alias ls="ls -AhFv --color=auto --group-directories-first"
alias ll="ls -lahFv --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias ln="ln -v"
alias mkdir="mkdir -vp"

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
    git pull
    git add .
    git commit -m "notes backup: $(date --rfc-3339 s)"
    git push
}
