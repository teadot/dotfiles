#!/usr/bin/env bash

# Ask for sudo password upfront.
sudo -v

# Update existing sudo time stamp until installation has finished.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done &>/dev/null &

source ./install/update_system.sh

source ./install/apps.sh

source ./install/link_dotfiles.sh

source ./install/cleanup.sh