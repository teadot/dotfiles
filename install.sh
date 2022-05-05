#!/usr/bin/env bash

## export dotfiles path
export DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

## Ask for sudo password upfront.
sudo -v

## Update existing sudo time stamp until installation has finished.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done &>/dev/null &

## intall latest git via ppa (https://git-scm.com/download/linux)
sudo add-apt-repository --ppa ppa:git-core/ppa --yes

# upgrade the system
sudo apt update
sudo apt upgrade --yes
sudo apt dist-upgrade --yes

## install homebrew
sudo apt install --no-install-recommends build-essential gcc --yes
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

## install stow via homebrew
brew install stow

## link dotfiles
stow -vSt ${HOME} dots

## install other stuff via homebrew
brew bundle --file=${DOTFILES_DIR}/install/Brewfile || true

## if fnm is installed
if brew ls --versions fnm > /dev/null; then
    eval "$(fnm env)"
    ## install latest lts node.js via fnm
    fnm install --lts

    ## install global npm packages
    npm install -g $(cat ${DOTFILES_DIR}/install/npmfile)
fi

## remove unneeded packages
sudo apt autoremove --yes
