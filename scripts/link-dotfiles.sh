#!/usr/bin/env bash

set -eou pipefail

main() {
    local DOTFILES_DIR="$HOME/personal/dotfiles"
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "dotfiles directory not found at '$DOTFILES_DIR'"
        exit 1
    fi

    local IGNORE_LIST=(".git" "scripts" ".gitignore" "README.md" "tlp" "awesome" "rofi" "ssh" "xmodmap" "copyq")

    for dir in "$DOTFILES_DIR"/*/; do
        local dirname=$(basename "$dir")
        local linkpath="$XDG_CONFIG_HOME/$dirname"

        if [[ " ${IGNORE_LIST[*]} " =~ " $dirname " ]]; then
            continue
        fi

        if [[ -L "$linkpath" || -e "$linkpath" ]]; then
            continue
        fi

        ln -sv "$dir" "$linkpath"
    done

    if [[ ! -L "/etc/tlp.d/01-mytlp.conf" && ! -e "/etc/tlp.d/01-mytlp.conf" ]]; then
        sudo ln -sv "$DOTFILES_DIR/tlp/01-mytlp.conf" '/etc/tlp.d/01-mytlp.conf'
    fi

    if [[ ! -L "$HOME/.ssh/config" && ! -e "$HOME/.ssh/config" ]]; then
        ln -sv "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
    fi
}

main
