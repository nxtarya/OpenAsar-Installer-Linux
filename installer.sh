#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo -e "\e[1;31mError: This script must be run as root. Please use sudo.\e[0m"
    exit 1
fi

declare -a paths=(
    "/opt/discord/resources/app.asar"
    "/usr/lib/discord/resources/app.asar"
    "/usr/lib64/discord/resources/app.asar"
    "/usr/share/discord/resources/app.asar"
    "/var/lib/flatpak/app/com.discordapp.Discord/current/active/files/discord/resources/app.asar"
    "$HOME/.local/share/flatpak/app/com.discordapp.Discord/current/active/files/discord/resources/app.asar"
)

USER_APP_ASAR="$1"

function copy_app_asar {
    for path in "${paths[@]}"; do
        if [ -e "$path" ]; then
            echo -e "\e[1;32mFound app.asar at: $path\e[0m"
            sudo cp "$USER_APP_ASAR" "$path"
            if [ $? -eq 0 ]; then
                echo -e "\e[1;32mSuccessfully overwritten app.asar in $path\e[0m"
            else
                echo -e "\e[1;31mError: Failed to overwrite app.asar in $path\e[0m"
            fi
            return 0
        fi
    done
    echo -e "\e[1;33mWarning: No valid app.asar path found. Proceeding without overwriting.\e[0m"
    return 1
}

if [ -z "$USER_APP_ASAR" ]; then
    echo -e "\e[1;34m
----------------------
| Welcome to the     |
| OpenAsar Installer |
----------------------
\e[0m"
    echo -e "\e[1;33mUsage: sudo $0 /path/to/your/app.asar\e[0m"
    exit 1
fi

if [ ! -f "$USER_APP_ASAR" ]; then
    echo -e "\e[1;33mWarning: The specified app.asar file does not exist: $USER_APP_ASAR\e[0m"
fi

copy_app_asar

echo -e "\e[1;34mOpenAsar by GooseMod - Installer by NotArya\e[0m"
