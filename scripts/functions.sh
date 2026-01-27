upgrade() {
    sudo apt update
    sudo apt upgrade
    flatpak update
    pipx upgrade-all
    mise upgrade
}

autoremove() {
    sudo apt autoremove -y --purge
    flatpak remove --unused
    mise prune
}