#!/usr/bin/env bash

set -eou pipefail

set_up_xdg_base_directory() {
    cat <<'EOF' >>~/.bashrc
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export DOTFILES_DIR="$HOME/personal/dotfiles"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

alias vim="nvim"
alias htop="btop"
EOF
    # TODO: why simply `source ~/.bashrc` after writing the variables into it
    # doesn't work?
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CACHE_HOME="$HOME/.cache"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_STATE_HOME="$HOME/.local/state"
    export DOTFILES_DIR="$HOME/personal/dotfiles"
    export PATH="$PATH:$HOME/.local/bin" # Add the pipx bin directory to PATH
}

set_performance_power_mode() {
    powerprofilesctl set performance
}

update_system() {
    sudo apt update
    sudo apt upgrade -y
}

enable_ssd_trim() {
    sudo systemctl start fstrim.timer
    sudo systemctl enable fstrim.timer
}

reduce_swappiness() {
    echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf
}

enable_firewall() {
    sudo ufw enable
}

create_default_dirs() {
    mkdir -vp "$XDG_DATA_HOME"/bash-completion/completions
    mkdir -vp ~/Pictures/Screenshots
    mkdir -vp ~/Videos/Recordings
    mkdir -vp ~/personal
}

set_up_flatpak() {
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
        org.nickvision.tubeconverter \
        com.github.johnfactotum.Foliate \
        com.obsproject.Studio
}

install_mise_tools() {
    tools=(
        aws-cli
        node@lts
        npm:eslint
        pipx
        prettier
        shellcheck
        shfmt
        stylua
        usage
    )
    for tool in "${tools[@]}"; do
        mise use -g "${tool}"
    done
    eval "$(mise activate bash --shims)" # Adds the activated tools to $PATH
    mise completion bash --include-bash-completion-lib >"$XDG_DATA_HOME"/bash-completion/completions/mise
    pipx ensurepath
    echo 'eval "$(register-python-argcomplete pipx)"' >>~/.bashrc
}

install_python_packages() {
    pipx install argcomplete tldr awscli-local[ver1]
    tldr --print-completion bash >"$XDG_DATA_HOME"/bash-completion/completions/tldr
}

install_packages() {
    sudo apt install -y \
        ubuntu-restricted-extras \
        build-essential \
        curl \
        xclip \
        transmission \
        flameshot \
        gparted \
        gnome-software \
        gnome-software-plugin-flatpak \
        gnome-software-plugin-snap \
        timeshift \
        btop \
        uuid \
        ripgrep \
        jq \
        python3-venv

    # Install Google Chorome
    cd /tmp
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    xdg-settings set default-web-browser google-chrome.desktop
    # Configure the default browser to handle `whatsapp:` links
    xdg-mime default "$(xdg-settings get default-web-browser)" 'x-scheme-handler/whatsapp'
    cd -

    # Install Docker
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt update
    sudo apt install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
    if ! getent group docker >/dev/null; then
        sudo groupadd docker
    fi
    sudo usermod -aG docker "$USER"

    # Install Spotify
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update
    sudo apt install -y spotify-client

    # Install Ngrok
    curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
    sudo apt update
    sudo apt install -y ngrok

    # Install fastfetch
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    sudo apt update
    sudo apt install -y fastfetch

    # Install GitHub CLI
    sudo mkdir -p -m 755 /etc/apt/keyrings
    out=$(mktemp)
    wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
    cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt update
    sudo apt install -y gh

    # Install mise
    sudo install -dm 755 /etc/apt/keyrings
    curl -fSs https://mise.jdx.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.asc 1>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.asc] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
    sudo apt update
    sudo apt install -y mise
    echo 'eval "$(mise activate bash)"' >>~/.bashrc
    install_mise_tools

    # Install copyq
    # sudo add-apt-repository -y ppa:hluk/copyq
    # sudo apt update
    # sudo apt install -y copyq

    # Install VS Code
    cd /tmp
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
    sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
    cat <<EOF | sudo tee /etc/apt/sources.list.d/vscode.sources >/dev/null
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
    sudo apt update
    sudo apt install -y apt-transport-https code
    cd -

    # Install AnyDesk
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY -o /etc/apt/keyrings/keys.anydesk.com.asc
    sudo chmod a+r /etc/apt/keyrings/keys.anydesk.com.asc
    echo "deb [signed-by=/etc/apt/keyrings/keys.anydesk.com.asc] https://deb.anydesk.com all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list >/dev/null
    sudo apt update
    sudo apt install -y apt-transport-https anydesk

    # Install Neovim
    cd /tmp
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    cd -

    # Install FortiClient VPN
    cd /tmp
    wget -qO forticlient_vpn_amd64.deb https://links.fortinet.com/forticlient/deb/vpnagent
    sudo apt install -y ./forticlient_vpn_amd64.deb
    cd -

    install_python_packages
    set_up_flatpak
    install_flatpaks
}

set_up_github_ssh() {
    local SSH_KEY_PATH="$HOME/.ssh/github"
    local EMAIL="iranbrgasf@gmail.com"
    local TITLE=$(hostnamectl hostname)
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_KEY_PATH" -N ""
    eval "$(ssh-agent -s)"
    ssh-add "$SSH_KEY_PATH"
    gh auth login --git-protocol ssh --skip-ssh-key --web --scopes admin:public_key
    gh ssh-key add "$SSH_KEY_PATH.pub" --title "$TITLE"
}

set_up_dotfiles() {
    local current_dir=$(pwd)
    cd ~/personal
    git clone git@github.com:iranbragasf/dotfiles.git
    git clone git@github.com:iranbragasf/obsidian-vault.git
    cd ./dotfiles
    chmod +x ./bin/link-dotfiles.sh
    ./bin/link-dotfiles.sh
    cd "$current_dir"
}

install_fonts() {
    cd /tmp

    # Install Symbols Only Nerd Font
    wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.tar.xz
    mkdir -vp NerdFontsSymbolsOnly
    tar -xvf NerdFontsSymbolsOnly.tar.xz -C ./NerdFontsSymbolsOnly
    sudo mkdir -vp /usr/share/fonts/truetype/nerdfontssymbolsonly
    sudo mv ./NerdFontsSymbolsOnly/*.ttf /usr/share/fonts/truetype/nerdfontssymbolsonly

    # Install JetBrainsMono Nerd Font
    wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    mkdir -vp JetBrainsMono
    tar -xvf JetBrainsMono.tar.xz -C ./JetBrainsMono
    sudo mkdir -vp /usr/share/fonts/truetype/jetbrainsmono
    sudo mv ./JetBrainsMono/*.ttf /usr/share/fonts/truetype/jetbrainsmono

    fc-cache -fv
    cd -
}

copy_wallpapers() {
    mkdir -vp "$XDG_DATA_HOME/backgrounds"
    cp -v "$DOTFILES_DIR/wallpapers/"* "$XDG_DATA_HOME/backgrounds/"
}

set_up_gnome() {
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action "minimize-or-previews"
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
    gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
    gsettings set org.gnome.shell.extensions.ding show-home false
    gsettings set org.gnome.shell.extensions.ding start-corner "top-left"
    gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'yelp.desktop']"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Yaru-dark'
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Mono 13'
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
    gsettings set org.gnome.desktop.peripherals.mouse accel-profile "flat"
    gsettings set org.gnome.desktop.session idle-delay 0
    gsettings set org.gnome.desktop.background picture-uri "file://$XDG_DATA_HOME/backgrounds/mblabs.png"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$XDG_DATA_HOME/backgrounds/mblabs.png"
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
    gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4112
    gsettings set org.gnome.mutter center-new-windows true

    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

    gsettings set org.gnome.shell.keybindings show-screenshot-ui '[]'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Screenshot entire screen to clipboard'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'flameshot screen --clipboard'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Screenshot entire screen and save to the screenshots directory'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "flameshot screen --path $HOME/Pictures/Screenshots"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Super>Print'

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Screenshot region'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'flameshot gui'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Super><Shift>s'

    # TODO: set up clipboard manager. See: https://youtube.com/shorts/GKGnx1zMdEI?si=nE-51FQOpskGqvfS
    # gsettings set org.gnome.shell.keybindings toggle-message-tray '[]'
    # gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'Open clipboard history'
    # gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'copyq toggle'
    # gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Super>v'

    # TODO: <Super>.	    Open emoji picker
    # TODO: <Super><A-r>	Record the screen
}

# NOTE: for some reason Gnome freezes when pressing media keys.
# See: https://tinyurl.com/73amac83
disable_scroll_lock_mod3() {
    local keymap_layout_path="/usr/share/X11/xkb/symbols/br"
    sudo cp -v "$keymap_layout_path" "$keymap_layout_path.bak"
    sudo sed -i '/^[[:space:]]*modifier_map Mod3[[:space:]]\+{ Scroll_Lock };/s/^/\/\/ /' "$keymap_layout_path"
}

cleanup() {
    sudo apt autoremove -y --purge
    flatpak remove --unused
}

reboot_system() {
    systemctl reboot
}

main() {
    set_up_xdg_base_directory
    set_performance_power_mode
    update_system
    enable_ssd_trim
    reduce_swappiness
    enable_firewall
    create_default_dirs
    install_packages
    set_up_github_ssh
    set_up_dotfiles
    install_fonts
    copy_wallpapers
    set_up_gnome
    disable_scroll_lock_mod3
    cleanup
    reboot_system
}

main
