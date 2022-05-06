# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

# source .prompt-file
if [ -f "$HOME/.prompt" ]; then
  . "$HOME/.prompt"
fi

# set DOTFILES_DIR var
if [ -d "$HOME/.dotfiles" ] ; then
  DOTFILES_DIR="$HOME/.dotfiles"
fi

# set PATH for brew
if [ -d "/home/linuxbrew/.linuxbrew/bin/" ]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin/":$PATH
fi

# set autocomplete for brew
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -d "${HOMEBREW_PREFIX}/etc/bash_completion.d/" ]]
  then
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# init fnm
if type fnm &>/dev/null
then
  eval "$(fnm env)"
fi

# set autocomplete vor pyenv
if type pyenv &>/dev/null
then
  eval "$(pyenv init -)"
fi

# set envvars for dotnet
if type dotnet &>/dev/null
then
  export DOTNET_CLI_TELEMETRY_OPTOUT=1

  # if dotnet is installed via brew
  #if [[ -d "/home/linuxbrew/.linuxbrew/opt/dotnet/libexec/" ]];
  #then
  #  export DOTNET_ROOT="/home/linuxbrew/.linuxbrew/opt/dotnet/libexec"
  #fi

fi
