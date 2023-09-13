#!/bin/bash

source "$(cd "$(dirname "$0")" && pwd)/colors.txt"

echo "${CYAN}INFO: Installing Vundle and plugins${ESC_END}"

if [ ! -d "${HOME}/.vim/bundle" ] ; then
  mkdir -p "${HOME}/.vim/bundle/Vundle.vim"
fi

git clone https://github.com/VundleVim/Vundle.vim.git "${HOME}/.vim/bundle/Vundle.vim"
vim +PluginInstall +qall

echo "${GREEN}INFO: Done${ESC_END}"
