upgrade() {
    sudo apt update
    sudo apt upgrade
    flatpak update
    pipx upgrade-all
    mise upgrade
    # npm update
}

autoremove() {
    sudo apt autoremove -y --purge
    flatpak remove --unused
    mise prune
    # npm prune
}
