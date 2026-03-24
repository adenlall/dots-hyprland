# Polkit settup
job=0
while true; do
    printf "\n${STY_YELLOW}"
    printf "🌟 Icon themes with foloder auto accent color theming"
    printf "${STY_PURPLE}\nRequirements :\n"
    printf "${STY_RED}${STY_BOLD}"
    printf "\t- xmlstarlet : extra/xmlstarlet\n"
    printf "${STY_YELLOW}${STY_RST}\n"
    read -p "Enable && Install requirements ? (Y/n) [default=N] " -r ANSWER
    if [[ -z "$ANSWER" ]]; then
        break
    fi
    case "$ANSWER" in
        [Yy] ) $job=1; break ;;
        [Nn] ) echo "Aborting!.";  break ;;
        * )    echo "Please answer Y or n, or press Enter for yes."; break ;;
    esac
done

if (( $job==1 )); then

    yay -S --needed fzf
    themes=("None" "All" "Papirus" "WhiteSur")

    selected=$(printf "%s\n" "${themes[@]}" | fzf --prompt="Select Icon theme to be isntalled: ")

    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    case $selected in
        "WhiteSur")
            source $script_dir/themes/0.install.whitesur.sh
            ;;
        "Papirus")
            source $script_dir/themes/1.install.papirus.sh
            ;;
        "All")
            source $script_dir/themes/1.install.papirus.sh
            source $script_dir/themes/0.install.whitesur.sh
            ;;
        "None")
            exit 0
            ;;
        *)
            exit 0
        ;;
    esac

    printf "\n${STY_GREEN}${STY_BOLD}"
    echo "-----------------------------------"
    printf "$selected installed successfuly!\n"
    echo "-----------------------------------"
    printf "\n${STY_GREEN}${STY_RST}"

    printf "\n${STY_YELLOW}${STY_BOLD}"
    echo "-----------------------------------"
    printf "You need to Reload the shell to apply the Icon theme globaly! [Super+Ctrl+R]\n"
    echo "-----------------------------------"
    printf "\n${STY_YELLOW}${STY_RST}"
fi