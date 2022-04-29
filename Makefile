SHELL := /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PATH := $(DOTFILES_DIR)/bin:$(PATH)
BREW := $(shell brew --version 2> /dev/null)


all: ubuntu-core brew-packages

ubuntu-core:
	sudo -v
	sudo apt update
	sudo apt upgrade --yes
	sudo apt dist-upgrade --yes
	sudo apt autoremove --yes
		
brew: git
	is-executable brew || /bin/bash -c $(DOTFILES_DIR)/install/brew.sh

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || true

stow: brew
	is-executable stow || brew install stow

link: stow
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config