# Polkit settup

ICON_PACK="WhitseSurs"
ICON_DIR="$XDG_DATA_HOME/icons/$ICON_PACK"
ICON_GIT="https://github.com/vinceliuice/WhiteSur-icon-theme"
INSTALL_DIR="/tmp/$ICON_PACK-install-end4"

while true; do
    printf "\n${STY_YELLOW}"
    printf "Enable Folder auto theming using White sur Icon theme"
    printf "${STY_PURPLE}\nRequirements :\n"
    printf "${STY_RED}${STY_BOLD}"
    printf "\t- $ICON_PACK : $ICON_GIT\n"
    printf "\t- xmlstarlet : extra repo\n"
    printf "${STY_YELLOW}${STY_RST}\n"
    read -p "Install requirements ? (Y/n)" -r ANSWER
    if [[ -z "$ANSWER" ]]; then
        break
    fi
    case "$ANSWER" in
        [Yy] ) break ;;
        [Nn] ) echo "Aborting!."; exit 0 ;;
        * )    echo "Please answer Y or n, or press Enter for yes." ;;
    esac
done


printf "${STY_CYAN}"
printf "Cloning "
printf "${STY_RED}${STY_BOLD}"
printf "$ICON_GIT "
printf "${STY_CYAN}${STY_RST}"
printf "into : "
printf "${STY_RED}${STY_BOLD}"
printf "/tmp/$ICON_PACK-install\n"
printf "${STY_RED}${STY_RST}"


if [ -d "$INSTALL_DIR" ]; then
    rm -rf $INSTALL_DIR
fi

git clone $ICON_GIT $INSTALL_DIR
bash /tmp/$ICON_PACK-install/install.sh -b


if [ ! -d "$ICON_DIR" ]; then
    echo "Error: can't find the $ICON_PACK icon pack '$ICON_DIR' !"
    while true; do
        read -p "Do you wanna install $ICON_PACK icon pack ? (Y/n) " -r ANSWER
        if [[ -z "$ANSWER" ]]; then
            break
        fi
        case "$ANSWER" in
            [Yy] ) break ;;
            [Nn] ) echo "Aborting!."; exit 0 ;;
            * )    echo "Please answer Y or n, or press Enter for yes." ;;
        esac
    done
fi



printf "\n${STY_GREEN}${STY_BOLD}"
echo "-----------------------------------"
printf "$ICON_PACK installed successfuly!\n"
echo "-----------------------------------"
printf "\n${STY_GREEN}${STY_RST}"
