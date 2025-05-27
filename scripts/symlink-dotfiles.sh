#!/usr/bin/env bash

set -eou pipefail

main() {
    local IGNORE_LIST=(".git" "scripts" ".gitignore" "README.md" "tlp" "awesome" "rofi", "copyq")
    local SOURCE_DIR="$HOME/personal/dotfiles"
    local TARGET_DIR="$XDG_CONFIG_HOME"

    for dir in "$SOURCE_DIR"/*/; do
        local dirname=$(basename "$dir")
        local linkpath="$TARGET_DIR/$dirname"

        if [[ " ${IGNORE_LIST[*]} " =~ " $dirname " ]]; then
            continue
        fi

        if [[ -L "$linkpath" || -e "$linkpath" ]]; then
            continue
        fi

        ln -vs "$dir" "$linkpath"
    done

    sudo ln -vs "$SOURCE_DIR/tlp/01-mytlp.conf" '/etc/tlp.d/'
}

main
