upgrade() {
    sudo apt update
    sudo apt upgrade
    flatpak update
    pipx upgrade-all
}

autoremove() {
    sudo apt autoremove -y
    flatpak remove --unused
}