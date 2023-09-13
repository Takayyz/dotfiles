#!/bin/bash

source "$(cd "$(dirname "$0")" && pwd)/colors.txt"

echo "${CYAN}INFO: Installing Vundle and plugins${ESC_END}"

if [ ! -d ~/.vim/bundle ] ; then
  mkdir -p ~/.vim/bundle/Vundle.vim
fi

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "${GREEN}INFO: Done${ESC_END}"
