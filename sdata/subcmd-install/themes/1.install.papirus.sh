
ICON_PACK="papirus"
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


if [ -d "$INSTALL_DIR" ]; then
    rm -rf $INSTALL_DIR
fi

git clone --depth 1 $GIT $INSTALL_DIR
cp -r $INSTALL_DIR/Papirus/ ~/.local/share/icons/
sed -i "s/^iconslight = .*/iconslight = $ICON_PACK/" "$XDG_CONFIG_HOME/kde-material-you-colors/config.conf"
sed -i "s/^iconsdark = .*/iconsdark = $ICON_PACK/" "$XDG_CONFIG_HOME/kde-material-you-colors/config.conf"
sed -i "/^\[Icons\]/,/^\[/ s/^Theme=.*/Theme=$ICON_PACK/" "$XDG_CONFIG_HOME/kdeglobals"
gsettings set org.gnome.desktop.interface icon-theme $ICON_PACK