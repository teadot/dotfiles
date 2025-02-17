#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Variables
OH_MY_ZSH_UPGRADE_SCRIPT="/home/${USER}/.oh-my-zsh/tools/upgrade.sh"

# Function to perform updates that require sudo
update_and_cleanup_apt() {
    # Update via apt
    echo "-> Update via apt"
    sudo apt update -qq && sudo apt upgrade -qq --yes
    if [ $? -ne 0 ]; then
        echo "Error: apt update/upgrade failed"
        exit 1
    fi
    echo -e "\n"

    # Cleanup
    echo "-> Cleanup apt"
    sudo apt autoremove -qq --yes
    if [ $? -ne 0 ]; then
        echo "Error: apt autoremove failed"
        exit 1
    fi
    echo -e "\n"
}

# Function to update and cleanup brew
update_and_cleanup_brew() {
    # Update via brew
    echo "-> Update via brew"
    export HOMEBREW_NO_ENV_HINTS=1
    brew update -q && brew upgrade -q
    if [ $? -ne 0 ]; then
        echo "Error: brew update/upgrade failed"
        exit 1
    fi
    echo -e "\n"

    # Cleanup brew
    echo "-> Cleanup brew"
    brew cleanup -s
    if [ $? -ne 0 ]; then
        echo "Error: brew cleanup failed"
        exit 1
    fi
    echo -e "\n"
}

# Display a fancy banner
echo '/==============================================================================\'
echo '||                                                                            ||'
echo '||    ____            _                                   _       _           ||'
echo '||   / ___| _   _ ___| |_ ___ _ __ ___    _   _ _ __   __| | __ _| |_ ___     ||'
echo '||   \___ \| | | / __| __/ _ \ '\''_ ` _ \  | | | | '\''_ \ / _` |/ _` | __/ _ \    ||'
echo '||    ___) | |_| \__ \ ||  __/ | | | | | | |_| | |_) | (_| | (_| | ||  __/    ||'
echo '||   |____/ \__, |___/\__\___|_| |_| |_|  \__,_| .__/ \__,_|\__,_|\__\___|    ||'
echo '||          |___/                              |_|                            ||'
echo '||                                                                            ||'
echo '\==============================================================================/'
echo -e "\n"

# Perform updates that require sudo
sudo bash -c "$(declare -f update_and_cleanup_apt); update_and_cleanup_apt"

# Update and cleanup brew
update_and_cleanup_brew

# Update oh my zsh
echo "-> Update oh my zsh"
$OH_MY_ZSH_UPGRADE_SCRIPT
if [ $? -ne 0 ]; then
    echo "Error: oh my zsh update failed"
    exit 1
fi
echo -e "\n"

echo "Update completed!"