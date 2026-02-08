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
		if [[ "$dotfile" = "${SCRIPT_DIR}/.zshenv" ]]; then
			ln -snfv "$dotfile" "$HOME"
    elif [[ "$dotfile" = "${SCRIPT_DIR}/.z"* ]]; then
      ln -snfv "$dotfile" "${ZDOT_DIR:-$HOME}"
    else
      ln -snfv "$dotfile" "$HOME"
    fi
done

source ${ZDOT_DIR}/.zshrc

if [ ! -d "${HOME}/.config" ] ; then
  mkdir "${HOME}/.config"
fi
DOTCONF_DIR=${HOME}/.config

ln -snfv "${SCRIPT_DIR}/starship.toml" "${DOTCONF_DIR}"

# posting (config: ~/.config, themes: ~/.local/share)
if [ ! -d "${DOTCONF_DIR}/posting" ] ; then
  mkdir -p "${DOTCONF_DIR}/posting"
fi
ln -snfv "${SCRIPT_DIR}/posting/config.yaml" "${DOTCONF_DIR}/posting"

if [ ! -d "${HOME}/.local/share/posting" ] ; then
  mkdir -p "${HOME}/.local/share/posting"
fi
ln -snfv "${SCRIPT_DIR}/posting/themes" "${HOME}/.local/share/posting"

if [ ! -d "${HOME}/.warp/themes" ] ; then
  mkdir -p "${HOME}/.warp/themes"
fi
ln -snfv "./warp/themes" "${HOME}/.warp/themes"

echo "${GREEN}INFO: Done${ESC_END}"
