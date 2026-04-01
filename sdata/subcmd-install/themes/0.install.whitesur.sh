
ICON_PACK="WhiteSur"
ICON_DIR="$HOME/.local/share/icons/$ICON_PACK"
GIT="https://github.com/vinceliuice/WhiteSur-icon-theme"
INSTALL_DIR="/tmp/$ICON_PACK-install-end4"


printf "${STY_CYAN}"
printf "Cloning "
printf "${STY_RED}${STY_BOLD}"
printf "$GIT "
printf "${STY_CYAN}${STY_RST}"
printf "into : "
printf "${STY_RED}${STY_BOLD}"
printf "/tmp/$ICON_PACK-install\n"
printf "${STY_RED}${STY_RST}"

whitesur(){
    rm -rf "$INSTALL_DIR"
    git clone --depth 1 --branch master "$GIT" "$INSTALL_DIR"
    bash "$INSTALL_DIR/install.sh" -b
    
    terms=("" "-download" "-documents" "-bookmark" "-cloud" "-code" "-dropbox" "-games" "-github" "-html" "-images" "-music" "-projects" "-public" "-root" "-temp" "-templates" "-torrent" "-vbox" "-videos" "-wine")
    for term in "${terms[@]}"; do
        target_folder="$ICON_DIR/places/scalable/folder${term}.svg"
        source_folder="$ICON_DIR/places/scalable/pink-folder${term}.svg"
        cp "$source_folder" "$target_folder"
    done

    terms=("-home" "-desktop")
    for term in "${terms[@]}"; do
        target_folder="$ICON_DIR/places/scalable/user${term}.svg"
        source_folder="$ICON_DIR/places/scalable/pink-user${term}.svg"
        cp "$source_folder" "$target_folder"
    done

}

if [[ -d "$ICON_DIR" && "$SKIP_UPDATE_ICONS" == true ]]; then
    printf "\n%b--skip-updateicons => Skipping reinstalling icon pack since it already exists!%b\n" \
        "${STY_RED}${STY_BOLD}" "${STY_CYAN}${STY_RST}"
else
    whitesur
fi

rm -rf "$INSTALL_DIR"
sed -i "s/^iconslight = .*/iconslight = $ICON_PACK/" "$XDG_CONFIG_HOME/kde-material-you-colors/config.conf"
sed -i "s/^iconsdark = .*/iconsdark = $ICON_PACK/" "$XDG_CONFIG_HOME/kde-material-you-colors/config.conf"
sed -i "/^\[Icons\]/,/^\[/ s/^Theme=.*/Theme=$ICON_PACK/" "$XDG_CONFIG_HOME/kdeglobals"
gsettings set org.gnome.desktop.interface icon-theme $ICON_PACK
