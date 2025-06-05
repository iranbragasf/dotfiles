#!/usr/bin/env bash

set -eou pipefail

# NOTE: It's important to back up the system before removing snaps to guarantee
# that it's possible to restore the system in case something breaks.

main() {
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

main
