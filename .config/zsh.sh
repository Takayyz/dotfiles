#!/bin/bash

source "$(cd "$(dirname "$0")" && pwd)/colors.txt"

# --------------------------------------------------------------------------------
# Setup zprezto
# --------------------------------------------------------------------------------
echo "${CYAN}INFO: Setup zprezto...${ESC_END}"
source ${HOME}/.zshenv
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
