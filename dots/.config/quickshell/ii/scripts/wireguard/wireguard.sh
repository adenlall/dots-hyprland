#!/bin/bash
# Proton VPN WireGuard connection script for Arch Linux
# Usage: ./protonvpn-wireguard.sh up|down [config-file]

set -e

# Color codes for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Default config file locations (in order of preference)
DEFAULT_CONFIG_PATHS=(
    "$HOME/.local/wireguard"
    "/etc/wireguard"
)

# Function to print error and exit
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Function to print info
info() {
    echo -e "${GREEN}Info: $1${NC}"
}

# Function to print warning
warning() {
    echo -e "${YELLOW}Warning: $1${NC}"
}

# Check if running as root, if not re-exec with sudo
# if [[ $EUID -ne 0 ]]; then
#     if command -v sudo &>/dev/null; then
#         exec sudo "$0" "$@"
#     else
#         error_exit "This script must be run as root. Please install sudo or run as root."
#     fi
# fi

# Check if wireguard-tools is installed
if ! command -v wg-quick &>/dev/null; then
    error_exit "wg-quick not found. Please install wireguard-tools: sudo pacman -S wireguard-tools"
fi

# Check arguments
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 up|down [config-file]"
    exit 1
fi

ACTION="$1"
CONFIG_FILE="$2"

REQUIRES_CONFIG=("up" "down" "save" "strip")
action_needs_config() { # check if the the config is required
    local act="$1"
    for needed in "${REQUIRES_CONFIG[@]}"; do
        if [[ "$act" == "$needed" ]]; then
            return 0   # true, it needs config
        fi
    done
    return 1
}

if action_needs_config "$ACTION"; then

    if [[ -z "$CONFIG_FILE" ]]; then
        error_exit "No configuration file found. Please provide a path or place one in: ${DEFAULT_CONFIG_PATHS[*]}"
    fi
fi

current() {
    for iface in $(sudo wg show interfaces); do
        if [[ -f "/etc/wireguard/$iface.conf" ]]; then
            echo "$iface"
        else
            echo "no matching"
        fi
    done
}

# Perform action
case "$ACTION" in
    kill)
        interfaces=$(current)
        wg-quick down "$interfaces"
        ;;
    live)
        current
        ;;
    pull)
        ls /etc/wireguard/
        ;;
    up)
        wg-quick up "$CONFIG_FILE"
        info "VPN is up. Current status:"
        wg show
        ;;
    down)
        wg-quick down "$CONFIG_FILE"
        info "VPN is down."
        ;;
    *)
        error_exit "Invalid action. Use 'up' or 'down'."
        ;;
esac