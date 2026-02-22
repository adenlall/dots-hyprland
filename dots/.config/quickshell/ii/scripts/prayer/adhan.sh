#!/bin/bash
JSON_FILE="$HOME/.config/illogical-impulse/config.json"

selected_file="$(kdialog --getopenfilename \
    "$HOME" \
    "Audio Files (*.mp3 *.wav *.flac *.ogg *.m4a)" \
    --title "Choose Adhan")"

if [[ -n "$selected_file" && -f "$selected_file" ]]; then

    jq --arg path "$selected_file" \
        '.bar.prayer.adhan = $path' \
        "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"

    echo "Saved Audio File in config.json"
else
    echo "No file selected."
fi