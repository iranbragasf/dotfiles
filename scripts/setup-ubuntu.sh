#!/usr/bin/env bash

set -eou pipefail

setup_xdg_base_directory_spec() {
cat << 'EOF' >> ~/.bashrc
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
EOF
    # TODO: why simply `source ~/.bashrc` after writing the variables into it
    # doesn't work?
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CACHE_HOME="$HOME/.cache"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_STATE_HOME="$HOME/.local/state"
}


update_system() {
    sudo apt update
    sudo apt upgrade -y
}

# TODO: fix the error: "ERRO metrics from this machine have already been reported and can be found in: /home/iranbraga/.cache/ubuntu-report/ubuntu.24.04"
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

# TODO: configure `apt` to download packages in parallel
# setup_parallel_download() {
# }

# TODO: auto set Google DNS for every new wifi and ethernet connection.
# setup_google_dns() {
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
        copyq \
        gnome-software \
        gnome-software-plugin-flatpak \
        timeshift

    # Install Google Chorome
    # TODO: log in and synchronize google chrome
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
    if ! getent group docker > /dev/null; then
        sudo groupadd docker
    fi
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

    # Install mise
    sudo install -dm 755 /etc/apt/keyrings
    wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
    sudo apt update
    sudo apt install -y mise
    echo 'eval "$(mise activate bash)"' >> ~/.bashrc
    #NOTE: mise has to be activated to be able to use the installed tools globally
    source ~/.bashrc
    mise use -g usage
    mkdir -vp ~/.local/share/bash-completion/completions/
    mise completion bash --include-bash-completion-lib > ~/.local/share/bash-completion/completions/mise
    # NOTE: source to enable completion immediatly
    source ~/.bashrc

    setup_flatpak
    install_flatpaks
}

setup_github_ssh() {
    local SSH_KEY_FILE="$HOME/.ssh/github"
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
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
    gsettings set org.gnome.desktop.session idle-delay 0
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.shell.extensions.ding show-home false
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4112
    gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false

    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

    gsettings set org.gnome.shell.keybindings show-screenshot-ui '[]'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Screenshot entire screen to clipboard'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'flameshot screen -c'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Screenshot entire screen to ~/Pictures/Screenshots'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'flameshot screen -p /home/iranbraga/Pictures/Screenshots'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Super>Print'

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Screenshot region'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'flameshot gui'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Super><Shift>s'

    gsettings set org.gnome.shell.keybindings toggle-message-tray '[]'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'Open clipboard history'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'copyq toggle'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Super>v'

    # TODO: <Super>.	    Open emoji picker
    # TODO: <Super><A-r>	Record the screen
}

create_screenshots_dir() {
    mkdir -vp ~/Pictures/Screenshots/
}

cleanup() {
    sudo apt autoremove -y --purge
}

reboot_system() {
    systemctl reboot
}

main() {
    # NOTE: XDG Base Directory must be set first of all because it's required
    # in the following steps
    setup_xdg_base_directory_spec
    update_system
    # disable_ubuntu_report
    enable_trim
    enable_firewall
    # setup_parallel_download
    # setup_google_dns
    install_packages
    setup_github_ssh
    setup_dotfiles
    setup_gnome
    create_screenshots_dir
    cleanup
    reboot_system
}

main
