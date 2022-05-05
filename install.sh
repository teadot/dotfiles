#!/usr/bin/env bash

## to get version of os
source /etc/os-release

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

## setup wsl2 before start
if grep -qi wsl2 /proc/version; then
  source ${DOTFILES_DIR}/install/wsl2.sh
fi

## intall latest git via ppa (https://git-scm.com/download/linux)
if [[ "$VERSION_ID" == "16.04" ]]; then
    sudo add-apt-repository ppa:git-core/ppa --yes
else
    sudo add-apt-repository --ppa ppa:git-core/ppa --yes
fi

## upgrade the system
sudo apt update
sudo apt upgrade --yes
sudo apt dist-upgrade --yes

## install git
sudo apt install --no-install-recommends git --yes

## install homebrew
sudo apt install --no-install-recommends build-essential gcc --yes
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

## install stuff via homebrew
brew bundle --file=${DOTFILES_DIR}/install/Brewfile || true

## check if stow is installed
if ! brew ls --version stow > /dev/null; then
    echo "*** Install stow to link dotfiles"  
    brew install stow
fi

## link dotfiles
files=$(cat ${DOTFILES_DIR}/install/unstowfiles)
for file in $files; do
  if [[ -f "${HOME}/${file}" ]]; then
    rm ${HOME}/${file}
  fi
done
stow -vSt ${HOME} dots

## if fnm is installed
if brew ls --versions fnm > /dev/null; then
    echo "*** lets install latest node.js LTS"
    eval "$(fnm env)"
    ## install latest lts node.js via fnm
    fnm install --lts

    echo "*** install global node packages"
    ## install global node packages via npm
    npm install -g $(cat ${DOTFILES_DIR}/install/npmfile)
fi

## remove unneeded packages
sudo apt autoremove --yes
