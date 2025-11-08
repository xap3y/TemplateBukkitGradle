#!/usr/bin/env bash

validate_folder_name() {
    local folder="$1"
    if [[ -z "$folder" ]]; then
        echo "Folder name cannot be empty."
        return 1
    fi

    if [[ ! "$folder" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Invalid folder name. Use only letters, numbers, underscores, and dashes."
        return 1
    fi
    return 0
}

while true; do
    read -rp "Enter the folder name: " folder_name
    validate_folder_name "$folder_name" && break
done

git clone "https://github.com/xap3y/TemplateBukkitGradle.git" "$folder_name"

if [[ $? -eq 0 ]]; then
    chmod +x "$folder_name/gradlew"
else
    echo "Failed to clone the repository."
fi