#!/bin/bash

echo "Installing Icon theme into '~/.local/share/icons/' ..."

ICON_PACK="WhiteSur"
ICON_DIR="$HOME/.local/share/icons/$ICON_PACK"
FOLDER_ICON="$ICON_DIR/places/scalable/folder.svg"
STATE_DIR="${STATE_DIR:-$HOME/.local/state}"   # set a default if not defined
COLOR_FILE="$STATE_DIR/quickshell/user/generated/colors.json"

if ! command -v jq &>/dev/null; then
        echo "Error: jq is not installed." >&2
        exit 1
fi

if [ ! -d "$ICON_DIR" ]; then
        echo "WhiteSur icon theme isn't installed in : ~/.local/share/icons/"
        exit 1
fi

if [[ ! -f "$COLOR_FILE" ]]; then
        echo "Error: Color file not found: $COLOR_FILE" >&2
        exit 1
fi

if [[ ! -f "$FOLDER_ICON" ]]; then
        echo "Can't locate the default folder.svg $FOLDER_ICON" >&2
        exit 1
fi

primary=$(jq -r '.primary' "$COLOR_FILE")
primary_container=$(jq -r '.primary_container' "$COLOR_FILE")
on_primary=$(jq -r '.on_primary' "$COLOR_FILE")
surface=$(jq -r '.surface_tint' "$COLOR_FILE")
secondary=$(jq -r '.secondary' "$COLOR_FILE")

echo "colors ::::   primary             :::: $primary"
echo "colors ::::   on_primary          :::: $on_primary"
echo "colors ::::   primary_container   :::: $primary_container"
echo "colors ::::   surface             :::: $surface"
echo "colors ::::   secondary           :::: $secondary"


if [[ ! -f "$FOLDER_ICON" ]]; then
        echo "Error: SVG file not found: $svg_file" >&2
        exit 1
fi

xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="b"]/svg:stop[1]/@stop-color' \
        -v $primary_container $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="b"]/svg:stop[2]/@stop-color' \
        -v $primary_container $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="c"]/svg:stop[1]/@stop-color' \
        -v $primary_container $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="c"]/svg:stop[2]/@stop-color' \
        -v $primary_container $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="d"]/svg:stop[1]/@stop-color' \
        -v $surface $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="d"]/svg:stop[2]/@stop-color' \
        -v $primary_container $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="d"]/svg:stop[3]/@stop-color' \
        -v $surface $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="e"]/svg:stop[1]/@stop-color' \
        -v $surface $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="e"]/svg:stop[2]/@stop-color' \
        -v $primary_container $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="e"]/svg:stop[3]/@stop-color' \
        -v $primary_container $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '//svg:linearGradient[@id="e"]/svg:stop[4]/@stop-color' \
        -v $surface $FOLDER_ICON
xmlstarlet ed -L -N svg="http://www.w3.org/2000/svg" \
        -u '////svg:path[contains(@d, "M2.21 2.38h2.695")]/@fill' \
        -v $primary $FOLDER_ICON

gsettings set org.gnome.desktop.interface icon-theme Hicolor
gsettings set org.gnome.desktop.interface icon-theme $ICON_PACK

echo "Finished!"