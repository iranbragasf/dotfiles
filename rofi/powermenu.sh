#!/usr/bin/env bash

set -euo pipefail

chosen_option=$(echo -e "Lock\nSuspend\nReboot\nShutdown\nLogout" | rofi -dmenu -i -p "Power Menu")

case "$chosen_option" in
    # TODO: Lock screen
    # "Lock")
    #     betterlockscreen -l
    #     ;;
    # TODO: integrate automatic lock on suspend
    "Suspend")
        systemctl suspend
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    "Logout")
        awesome-client 'awesome.quit()'
        ;;
esac
