#!/bin/bash

CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"

selected_file="$(kdialog --getopenfilename \
    "$HOME" \
    "Config Files (*.config *.conf)" \
    --title "Choose Wireguard Config File")"

if [[ -n "$selected_file" && -f "$selected_file" ]]; then
    jq --arg path "$selected_file" \
        '.networking.wireguard.tempConfigPath = $path' \
        "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "Saved File in config.json"
else
    echo "No file selected."
fi