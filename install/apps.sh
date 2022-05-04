#!/usr/bin/env bash

## intall latest git via ppa (https://git-scm.com/download/linux)
sudo add-apt-repository --ppa ppa:git-core/ppa --yes
sudo apt update
sudo apt install --no-install-recommends git --yes

## install homebrew
sudo apt install --no-install-recommends build-essential gcc --yes
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

## install stow via homebrew
brew install stow

## install other stuff via homebrew
brew bundle --file=${DOTFILES_DIR}/install/Brewfile || true

## install latest lts node.js via fnm
fnm install --lts

## install global npm packages
npm install -g $(cat ${DOTFILES_DIR}/install/npmfile)