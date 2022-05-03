#!/usr/bin/env bash

# intall git
sudo apt install git --yes --no-install-recommends

# install homebrew
sudo apt --no-install-recommends install build-essential gcc --yes
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || true

fnm install --lts

npm install -g $(cat ./install/npmfile)