
ICON_PACK="Papirus"
ICON_DIR="$HOME/icons/$ICON_PACK"
GIT="https://github.com/PapirusDevelopmentTeam/papirus-icon-theme"
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


papirus(){
    rm -rf "$INSTALL_DIR"
    git clone --depth 1 --branch master $GIT $INSTALL_DIR
    cp -r $INSTALL_DIR/Papirus/ ~/.local/share/icons/
}

if [[ -d "$ICON_DIR" && "$SKIP_UPDATE_ICONS" == true ]]; then
    printf "\n%b--skip-updateicons => Skipping reinstalling icon pack since it already exists!%b\n" \
        "${STY_RED}${STY_BOLD}" "${STY_CYAN}${STY_RST}"
else
    papirus
fi

rm -rf "$INSTALL_DIR"
sed -i "s/^iconslight = .*/iconslight = $ICON_PACK/" "$XDG_CONFIG_HOME/kde-material-you-colors/config.conf"
sed -i "s/^iconsdark = .*/iconsdark = $ICON_PACK/" "$XDG_CONFIG_HOME/kde-material-you-colors/config.conf"
sed -i "/^\[Icons\]/,/^\[/ s/^Theme=.*/Theme=$ICON_PACK/" "$XDG_CONFIG_HOME/kdeglobals"
gsettings set org.gnome.desktop.interface icon-theme $ICON_PACK