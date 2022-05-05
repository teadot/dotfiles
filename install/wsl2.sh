#!/usr/bin/env bash

## check if there is an internet connection
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if ! [ $? -eq 0 ]; then
    sudo cp /etc/resolv.conf /etc/resolv.conf.old
    sudo unlink /etc/resolv.conf
    sudo mv /etc/resolv.conf.old /etc/resolv.conf
    sudo cp ${DOTFILES_DIR}/install/resolv.conf /etc/resolv.conf
    sudo cp ${DOTFILES_DIR}/install/wsl.conf /etc/wsl.conf
fi
