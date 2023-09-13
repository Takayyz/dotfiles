#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source ${SCRIPT_DIR}/colors.txt

# --------------------------------------------------------------------------------
#   Identify macOS
# --------------------------------------------------------------------------------
if [ "$(uname)" != "Darwin" ] ; then
  echo "${RED}ERROR: Hmmm, it's not macOS...${ESC_END}"
  exit 1
fi

echo "${CYAN}INFO: Starting setup macOS${ESC_END}"

# --------------------------------------------------------------------------------
#   Install Xcode
# --------------------------------------------------------------------------------

# Command Line Tools for Xcode
xcode-select -v &> /dev/null
if [ $? -ne 0 ]; then
  echo "${CYAN}INFO: Installing Xcode...${ESC_END}"
else
  echo "${YELLOW}NOTICE: Xcode already exists${ESC_END}"
  echo "INFO: Reinstalling Xcode..."
  sudo rm -rf /Library/Developer/CommandLineTools
fi
xcode-select --install

# --------------------------------------------------------------------------------
# Setup vim
# --------------------------------------------------------------------------------
echo "${CYAN}INFO: Installing Vundle and plugins${ESC_END}"
# if [ ! -d ~/.vim/bundle ] ; then
#   mkdir -p ~/.vim/bundle/Vundle.vim
# fi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
echo "${GREEN}INFO: Done${ESC_END}"

# --------------------------------------------------------------------------------
# Setup nvm
# --------------------------------------------------------------------------------
if [ ! -d "$HOME/.nvm" ] ; then
  mkdir $HOME/.nvm
fi

# --------------------------------------------------------------------------------
# Install zprezto
# --------------------------------------------------------------------------------
echo "${CYAN}INFO: Installing and setup zprezto...${ESC_END}"
source $HOME/.zshenv
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# --------------------------------------------------------------------------------
# Install other apps
# --------------------------------------------------------------------------------
# if [  -x "`which wget`" ]; then
#   echo 'Install other Apps'
#   if [ ! -e "/Applications/forghetti.app" ]; then
#     # Forghetti
#     wget https://downloads.forghetti.com/Forghetti.dmg -O ~/Downloads/Forghetti.dmg
#     hdiutil mount ~/Downloads/Forghetti.dmg
#     cd /Volumes/forghetti\ 1.0.6/
#     cp -r forghetti.app /Applications/
#     cd ~/
#     hdiutil detach /Volumes/forghetti\ 1.0.6/
#   fi
#   echo 'done'
# fi

cat << EOS
Congrats!! You are all set!
Before close this window, run command below...
------------------------------------------------------------
which git
which php
which zsh
------------------------------------------------------------

Also don't forget to setup git config...
------------------------------------------------------------
git config --global user.name "username"
git config --global user.mail "your.email@address"
------------------------------------------------------------

Other things that you should do manually are below...
------------------------------------------------------------
Turn Spotlight off
Launch iTerm2 and apply preferences source directory from 'Prefernces > General > Prefernces'
  *source directory should be '/path/to/homedirectory/dotofiles/iterm2'
------------------------------------------------------------

Enjoy!
EOS
