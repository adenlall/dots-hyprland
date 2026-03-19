# Polkit settup

SOURCE="dots/polkit/adenlall.dots-hyprland.wireguard.policy"
DESTFILE="/usr/share/polkit-1/actions/adenlall.dots-hyprland.wireguard.policy"
USERNAME="$USER"

if [ ! -f "$SOURCE" ]; then
    echo "Error: Source file '$SOURCE' does not exist or is not a regular file."
    exit 1
fi

if [ -e "$DESTFILE" ]; then
    echo "Warning: Destination '$DESTFILE' already exists."
    echo "Overriding system files can be risky, especially files related to polkit."
    echo "This might affect system permissions and authentication."

    while true; do
        read -p "Are you sure you want to overwrite it? (Y/n) " -r ANSWER
        if [[ -z "$ANSWER" ]]; then
            break   # empty = yes, proceed
        fi
        case "$ANSWER" in
            [Yy] ) break ;;
            [Nn] ) echo "Copy cancelled."; exit 0 ;;
            * )    echo "Please answer Y or n, or press Enter for yes." ;;
        esac
    done
fi

TEMP_FILE=$(mktemp)
sed "s/<USERNAME>/$USERNAME/g" "$SOURCE" > "$TEMP_FILE"
sudo cp "$TEMP_FILE" "$DESTFILE"

if [ $? -eq 0 ]; then
    echo "File copied successfully to '$DESTFILE' with '<USERNAME>' replaced by '$USERNAME'."
else
    echo "Error: Copy failed."
    exit 1
fi