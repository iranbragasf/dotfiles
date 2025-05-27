#!/usr/bin/env bash

set -eou pipefail

update_system() {
    sudo apt update
    sudo apt upgrade -y
}

disable_ubuntu_report() {
    ubuntu-report send no
    sudo apt purge -y ubuntu-report
}

enable_trim() {
    sudo systemctl start fstrim.timer
    sudo systemctl enable fstrim.timer
}

enable_firewall() {
    sudo ufw enable
}

# setup_parallel_download() {
#     # TODO: configure `apt` to download packages in parallel
# }

# setup_google_dns() {
#     # TODO: auto set Google DNS for every new wifi and ethernet connection.
# }


setup_flatpak() {
    sudo apt install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

install_flatpaks() {
    flatpak install -y flathub \
        com.getpostman.Postman \
        com.discordapp.Discord \
        com.slack.Slack \
        io.dbeaver.DBeaverCommunity \
        md.obsidian.Obsidian \
        org.nickvision.tubeconverter
}

install_packages() {
    sudo apt install -y \
        ubuntu-restricted-extras \
        curl \
        zsh \
        tmux \
        neovim \
        tlp \
        tldr \
        xclip \
        transmission \
        flameshot \
        obs-studio \
        gparted \
        copyq

    # Install Google Chorome
    cd /tmp
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    xdg-settings set default-web-browser google-chrome.desktop
    cd -

    # Install Docker
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        sudo apt install -y \
            docker-ce \
            docker-ce-cli \
            containerd.io \
            docker-buildx-plugin \
            docker-compose-plugin
        sudo usermod -aG docker $USER

    # Install Spotify
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update
    sudo apt install -y spotify-client

    # Install Ngrok
    curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
        | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
        && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
        | sudo tee /etc/apt/sources.list.d/ngrok.list \
        && sudo apt update \
        && sudo apt install -y ngrok

    # Install fastfetch
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    sudo apt install -y fastfetch

    # Install GitHub CLI
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
        && sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt update \
        && sudo apt install -y gh

    setup_flatpak
    install_flatpaks
}

setup_github_ssh() {
    local SSH_KEY_FILE="$HOME/.ssh/id_ed25519"
    local EMAIL="iranbrgasf@gmail.com"
    local TITLE=$(hostname)
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_KEY_FILE" -N ""
    eval "$(ssh-agent -s)"
    ssh-add "$SSH_KEY_FILE"
    gh auth login --git-protocol ssh --skip-ssh-key --web --scopes admin:public_key
    gh ssh-key add "$SSH_KEY_FILE.pub" --title "$TITLE"
}

setup_dotfiles() {
    local current_dir=$(pwd)
    mkdir -vp ~/personal
    cd ~/personal
    git clone git@github.com:iranbrg/dotfiles.git
    cd ./dotfiles
    chmod +x ./scripts/symlink-dotfiles.sh
    ./scripts/symlink-dotfiles.sh
    cd "$current_dir"
}

setup_gnome() {
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action "minimize-or-previews"
    gsettings set org.gnome.mutter center-new-windows true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
    # gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaMono Nerd Font 10'
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.shell.extensions.ding show-home false
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4112

    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

    gsettings set org.gnome.shell.keybindings show-screenshot-ui '[]'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Screenshot entire screen to clipboard'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'flameshot screen -c'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '[Print]'

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Screenshot entire screen to ~/Pictures/Screenshots'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'flameshot screen -p /home/iranbraga/Pictures/Screenshots'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '[<Super>Print]'

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Screenshot region'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'flameshot gui'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '[<Super><Shift>s]'

    gsettings set org.gnome.shell.keybindings toggle-message-tray '[]'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'Open clipboard history'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'copyq menu'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '[<Super>v]'

    # TODO; <Super>.	    Open emoji picker
    # TODO; <Super><A-r>	Record the screen
}

setup_system_backup() {
    # TODO: set up timeshift from command line.
    sudo apt install -y timeshift
}

remove_snaps() {
    while [ "$(snap list | wc -l)" -gt 0 ]; do
        for snap in $(snap list | tail -n +2 | cut -d ' ' -f 1); do
            snap remove --purge "$snap" 2> /dev/null
        done
    done

    sudo systemctl stop snapd
    sudo systemctl disable snapd
    # Prevent the snapd service from being started or enabled
    sudo systemctl mask snapd
    sudo apt purge -y snapd
    # Prevent snapd from being upgraded automatically by apt
    sudo apt-mark hold snapd
    # Remove snap leftovers, if any
    sudo rm -rf ~/snap /var/snap /var/lib/snapd /var/cache/snapd
    # Prevent snap from being reinstalled
    echo -e 'Package: snapd\nPin: release a=*\nPin-Priority: -10' | sudo tee /etc/apt/preferences.d/nosnap.pref
}

cleanup() {
    sudo apt autoremove -y --purge
}

main() {
    update_system
    # TODO: fix the error: "ERRO metrics from this machine have already been reported and can be found in: /home/iranbraga/.cache/ubuntu-report/ubuntu.24.04"
    # disable_ubuntu_report
    enable_trim
    enable_firewall
    # setup_parallel_download
    # setup_google_dns
    install_packages
    setup_github_ssh
    setup_dotfiles
    setup_gnome
    # setup_system_backup
    # It's important to backup the system before removing snaps, to guarantee that nothing breaks.
    # remove_snaps
    cleanup

    # sudo apt install -y gnome-software gnome-software-common gnome-software-plugin-flatpak
    # TODO: log in and synchronize google chrome
}

main
