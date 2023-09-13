#!/bin/bash

source "$(cd "$(dirname "$0")" && pwd)/colors.txt"

if [ "$(uname)" != "Darwin" ] ; then
  echo "${RED}ERROR: Hmmm, it's not macOS...${ESC_END}"
  exit 1
fi

if [ ! -x "`which brew`" ] ; then
  echo "${CYAN}INFO: Installing homebrew...${ESC_END}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "${CYAN}INFO: Updating homebrew...${ESC_END}"
brew update
echo "${CYAN}INFO: Upgrading homebrew...${ESC_END}"
brew upgrade
brew -v

echo "${CYAN}INFO: Installing applications...${ESC_END}"

brew bundle --global

brew link --overwrite awscli

mkdir -p ~/.docker/cli-plugins
ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose

brew services start php@8.2

sudo sh -c "echo '/opt/homebrew/bin/zsh' >> /etc/shells"
chsh -s /opt/homebrew/bin/zsh # change shell to zsh
chmod -R go-w /opt/homebrew/share/zsh # Avoid showing warnings

echo "${GREEN}INFO: Done brew settings${ESC_END}"
