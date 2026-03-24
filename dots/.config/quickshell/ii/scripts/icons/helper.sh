#!/bin/bash


XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

ACTION="$1"
ICON_PACK="$2"

current () {
    gtkraw=$(grep -i 'gtk-icon-theme-name' ~/.config/gtk-3.0/settings.ini)
    kderaw=$(kreadconfig5 --file ~/.config/kdeglobals --group Icons --key Theme)
    # echo $gtkraw | cut -d '=' -f 2
    echo  $kderaw | cut -d '=' -f 2
}

theme () {
    icon_pack=$(current)
    scrpt="${icon_pack,,}"
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -e $SCRIPT_DIR/../colors/folders/$scrpt.sh ]]; then
        source $SCRIPT_DIR/../colors/folders/$scrpt.sh
    else
        echo "folder theming not support yet on $icon_pack icon theme"
        exit 1
    fi
}

pull () {
    icons=$(ls -d $HOME/.local/share/icons/*/)
    for p in $icons; do
        name=$(basename "$p") # remove the $HOME/.local/share/icons basename
        [[ "$name" != "default" ]] && echo "$name" # filter out the default/ dir for cursor theme
    done
}
change () {
    if [[ -z "$ICON_PACK" ]]; then
        error_exit "No Icon theme provided. Please provide a theme from: $HOME/.local/share/icons"
        exit 0
    fi
    if [[ ! -d "$XDG_DATA_HOME/icons/$ICON_PACK" ]]; then
        error_exit "$ICON_PACK does not exist on : $HOME/.local/share/icons"
        exit 0
    fi
    sed -i "s/^iconslight = .*/iconslight = $ICON_PACK/" "$XDG_CONFIG_HOME/kde-material-you-colors/config.conf"
    sed -i "s/^iconsdark = .*/iconsdark = $ICON_PACK/" "$XDG_CONFIG_HOME/kde-material-you-colors/config.conf"
    sed -i "/^\[Icons\]/,/^\[/ s/^Theme=.*/Theme=$ICON_PACK/" "$XDG_CONFIG_HOME/kdeglobals"
    gsettings set org.gnome.desktop.interface icon-theme Hicolor
    gsettings set org.gnome.desktop.interface icon-theme $ICON_PACK
}

case "$ACTION" in
    theme)
        theme
        ;;
    current)
        current
        ;;
    pull)
        pull
        ;;
    set)
        change
        ;;
    *)
        error_exit "Invalid action!"
        ;;
esac