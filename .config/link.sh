#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source ${SCRIPT_DIR}/colors.txt

echo "${CYAN}INFO: Creating symlinks to home directory...${ESC_END}"

if [ ! -d "${HOME}/.zsh.d" ] ; then
  mkdir "${HOME}/.zsh.d"
fi
ZDOT_DIR=${HOME}/.zsh.d

if [ ! -d "${HOME}/.config" ] ; then
  mkdir "${HOME}/.config"
fi
DOTCONF_DIR=${HOME}/.config

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
    elif [[ "$dotfile" = "alacritty.yml" ]]; then
      if [ ! -d "${DOTCONF_DIR}/alacritty" ] ; then
        mkdir -p "${DOTCONF_DIR}/alacritty"
      fi
      ln -snfv "$dotfile" "${DOTCONF_DIR}/alacritty"
    elif [[ "$dotfile" = "starship.toml" ]]; then
      ln -snfv "$dotfile" "${DOTCONF_DIR}"
    else
      ln -snfv "$dotfile" "$HOME"
    fi
done

source ${ZDOTDIR}/.zshrc

echo "${GREEN}INFO: Done${ESC_END}"
