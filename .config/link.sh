#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source ${SCRIPT_DIR}/colors.txt

echo "${CYAN}INFO: Creating symlinks to home directory...${ESC_END}"

if [ ! -d "${HOME}/.config" ] ; then
  mkdir "${HOME}/.config"
fi
DOTCONF_DIR=${HOME}/.config

# zsh: link .zshenv to $HOME, others to $ZDOTDIR ($HOME/.config/zsh)
ZSH_DIR="${SCRIPT_DIR}/zsh"
ZDOT_DIR="${DOTCONF_DIR}/zsh"
mkdir -p "$ZDOT_DIR"

ln -snfv "${ZSH_DIR}/.zshenv" "$HOME"
for zfile in "${ZSH_DIR}"/.z*; do
  [[ "$(basename "$zfile")" == ".zshenv" ]] && continue
  ln -snfv "$zfile" "$ZDOT_DIR"
done
ln -snfv "${ZSH_DIR}/abbreviations" "$ZDOT_DIR"
mkdir -p "$ZDOT_DIR/sheldon"
ln -snfv "${ZSH_DIR}/sheldon/plugins.toml" "$ZDOT_DIR/sheldon"

source "${ZDOT_DIR}/.zshrc"

# dotfiles in .config/ (non-zsh)
for dotfile in "${SCRIPT_DIR}"/.??* ; do
    [[ "$dotfile" == "${SCRIPT_DIR}/.git" ]] && continue
    [[ "$dotfile" == "${SCRIPT_DIR}/.gitignore" ]] && continue
    [[ "$dotfile" == "${SCRIPT_DIR}/.DS_Store" ]] && continue
    [[ "$dotfile" == "${SCRIPT_DIR}/.claude" ]] && continue

    ln -snfv "$dotfile" "$HOME"
done

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

# herdr (dir also holds runtime logs/sockets/session.json, so only link config.toml/agent-detection)
if [ ! -d "${DOTCONF_DIR}/herdr" ] ; then
  mkdir -p "${DOTCONF_DIR}/herdr"
fi
ln -snfv "${SCRIPT_DIR}/herdr/config.toml" "${DOTCONF_DIR}/herdr"
ln -snfv "${SCRIPT_DIR}/herdr/agent-detection" "${DOTCONF_DIR}/herdr"

echo "${GREEN}INFO: Done${ESC_END}"
