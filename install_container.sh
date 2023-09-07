#!/usr/bin/env sh

## export dotfiles path
export DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

FILE=/etc/os-release

if [ -f "$FILE" ]; then 
    . $FILE

    if [ "$ID" = "alpine " ]; then
      apk add curl

      curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ${HOME}/.git-prompt.sh
      cp ${DOTFILES_DIR}/dots/.prompt ${HOME}/.prompt
      echo ". ${HOME}/.git-prompt.sh; . ${HOME}/.prompt" > ${HOME}/.profile

      ENV=${HOME}/.profile; export ENV

    elif [ "$ID" = "ubuntu" ]; then
      curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ${HOME}/.bash_git
      cp ${DOTFILES_DIR}/dots/.prompt ${HOME}/.prompt
      cp ${DOTFILES_DIR}/dots/.bash_aliases ${HOME}/.bash_aliases
      echo "source ${HOME}/.bash_git; source ${HOME}/.prompt; source ${HOME}/.bash_aliases" > ${HOME}/.bashrc

    fi

fi
