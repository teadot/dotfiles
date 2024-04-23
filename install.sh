#!/usr/bin/env bash

## export dotfiles path
export DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

## to get version of os
source /etc/os-release

## Ask for sudo password upfront.
sudo -v

## Update existing sudo time stamp until installation has finished.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done &>/dev/null &

sudo add-apt-repository --ppa ppa:git-core/ppa --yes

## upgrade the system
sudo apt update
sudo apt upgrade --yes
sudo apt dist-upgrade --yes

## install git, zsh
sudo apt install --no-install-recommends git zsh --yes
## install dependencies for pyenv
sudo apt install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev --yes

## install pyenv
if [[ ! -d "${HOME}/.pyenv" ]]; then
  git clone https://github.com/pyenv/pyenv.git ${HOME}/.pyenv
else
  git -C ${HOME}/.pyenv pull
fi

## dependencies for rancher desktop
if [[ -f "/mnt/c/Users/F22ChrTor/.kube/config" ]]; then
  sudo apt install --no-install-recommends libsecret-1-0 --yes
  rm -f ${HOME}/.kube/config
  ln -s /mnt/c/Users/F22ChrTor/.kube/config ${HOME}/.kube/config
fi

## install homebrew
sudo apt install --no-install-recommends build-essential gcc --yes
if [[ ! -d "/home/linuxbrew/.linuxbrew" ]]; then
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

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
stow -vSt ${HOME} dots && stow -vSt ${HOME}/bin bin

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  ## install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
  git -C ${HOME}/.oh-my-zsh pull
fi

## install zsh plugins
### autosuggestions
if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
  git -C ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions pull
fi

### completions
if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-completions" ]]; then
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
else
  git -C ${HOME}/.oh-my-zsh/custom/plugins/zsh-completions pull
fi

## if fnm is installed
if brew ls --versions fnm > /dev/null; then
    ## install latest lts node.js via fnm
    echo "*** lets install latest node.js LTS"
    eval "$(fnm env)"
    fnm install lts-latest
    fnm default lts-latest

  ## install global node packages via npm
  echo "*** install global node packages"
  npm install -g $(cat ${DOTFILES_DIR}/install/npmfile)
fi

## if tfswitch is installed
if brew ls --version tfswitch > /dev/null; then
  # install latest terraform
  tfswitch -u
fi

## if az cli is installed
if brew ls --version az > /dev/null; then
  # Pfad zur Textdatei mit den Extension-Namen
  AZ_EXT_LIST="./install/az_extensions.txt"

  # Überprüfen, ob die Datei existiert und lesbar ist
  if [ ! -r "$AZ_EXT_LIST" ]; then
      echo "File $AZ_EXT_LIST does not exist or is not readable."
      exit 1
  fi

  # Schleife zum Lesen der Datei und Installation der Erweiterungen
  while IFS= read -r EXT_NAME || [ -n "$EXT_NAME" ]; do
      # Überprüfen, ob der Extension-Name nicht leer ist
      if [ -n "$EXT_NAME" ]; then
          # Installation der Erweiterung
          az extension add --name "$EXT_NAME"
      fi
  done < "$AZ_EXT_LIST"
fi

## set zsh as default shell
sudo chsh -s $(which zsh) $(whoami)

## generate ssh-key-pair for git repos
if [[ ! -f "${HOME}/.ssh/id_rsa_azure_devops" ]]; then
  ssh-keygen -t rsa -b 4096 -f ${HOME}/.ssh/id_rsa_azure_devops -C "torben.christ@freudenberg.com" -N ""
fi

## disable message of the day
touch ${HOME}/.hushlogin

## remove unneeded packages
sudo apt autoremove --yes
