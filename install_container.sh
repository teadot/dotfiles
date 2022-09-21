#!/usr/bin/env bash

## export dotfiles path
export DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

## if we are inside a docker container
curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ${HOME}/.bash_git
cp ${DOTFILES_DIR}/dots/.prompt ${HOME}/.prompt
cp ${DOTFILES_DIR}/dots/.bash_aliases ${HOME}/.bash_aliases
echo "source ${HOME}/.bash_git; source ${HOME}/.prompt; source ${HOME}/.bash_aliases" > ${HOME}/.bashrc
