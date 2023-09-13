#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source ${SCRIPT_DIR}/colors.txt

echo "${CYAN}INFO: Creating symlinks to home directory...${ESC_END}"

if [ ! -d "${HOME}/.zsh.d" ] ; then
  mkdir "${HOME}/.zsh.d"
fi
ZDOT_DIR=${HOME}/.zsh.d

for dotfile in "${SCRIPT_DIR}"/.??* ; do
    [[ "$dotfile" == ".git" ]] && continue
    [[ "$dotfile" == ".gitignore" ]] && continue
    [[ "$dotfile" == ".DS_Store" ]] && continue

    # -s create a symlink
    # -f force overwrite
    # -n replace existing symlink
    # -v display progress
		if [[ "$dotfile" = ".zshenv" ]]; then
			ln -snfv "$dotfile" "$HOME"
    elif [[ "$dotfile" = ".z"* ]]; then
      ln -snfv "$dotfile" "${ZDOT_DIR:-$HOME}"
    else
      ln -snfv "$dotfile" "$HOME"
    fi
done

source ${ZDOTDIR}/.zshrc


if [ ! -d "${HOME}/.config" ] ; then
  mkdir "${HOME}/.config"
fi
DOTCONF_DIR=${HOME}/.config

if [ ! -d "${DOTCONF_DIR}/alacritty" ] ; then
  mkdir "${DOTCONF_DIR}/alacritty"
fi
ln -snfv "${SCRIPT_DIR}/alacritty.yml" "${DOTCONF_DIR}/alacritty"

ln -snfv "${SCRIPT_DIR}/starship.toml" "${DOTCONF_DIR}"

echo "${GREEN}INFO: Done${ESC_END}"
