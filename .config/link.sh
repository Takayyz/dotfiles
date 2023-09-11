#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source ${SCRIPT_DIR}/colors.txt

echo "${CYAN}INFO: Creating symlinks to home directory...${ESC_END}"

if [ ! -d "$HOME/.zsh.d" ] ; then
  mkdir "$HOME/.zsh.d"
fi

if [ ! -d "$HOME/.config" ] ; then
  mkdir "$HOME/.config"
fi

ZDOTDIR=$HOME/.zsh.d
for dotfile in "${SCRIPT_DIR}"/.??* ; do
    [[ "$dotfile" == ".git" ]] && continue
    [[ "$dotfile" == ".gitignore" ]] && continue
    [[ "$dotfile" == ".DS_Store" ]] && continue

    # -s create a symlink
    # -f force overwrite
    # -n replace existing symlink
    # -v display progress
		if [[ "$dotfile" = ".alacritty" ]]; then
      if [ ! -d "$HOME/.config/alacritty" ] ; then
        mkdir "$HOME/.config/alacritty"
      fi
			ln -snfv "$dotfile" "$HOME/.config/alacritty"
		elif [[ "$dotfile" = ".zshenv" ]]; then
			ln -snfv "$dotfile" "$HOME"
    elif [[ "$dotfile" = ".z"* ]]; then
      ln -snfv "$dotfile" "${ZDOTDIR:-$HOME}"
    else
      ln -snfv "$dotfile" "$HOME"
    fi
done

echo "${GREEN}INFO: Done${ESC_END}"
