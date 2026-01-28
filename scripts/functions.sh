upgrade() {
    sudo apt update
    sudo apt upgrade
    flatpak update
    mise upgrade
    pipx upgrade-all
}

autoremove() {
    sudo apt autoremove -y --purge
    flatpak remove --unused
    mise prune
}
