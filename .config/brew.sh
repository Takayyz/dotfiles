#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source ${SCRIPT_DIR}/colors.txt

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

echo "${CYAN}INFO: Installing applications by homebrew...${ESC_END}"
brew install --cask alacritty
brew install --cask alfred
brew install --cask appcleaner
brew install --cask authy
brew install --cask chrome-remote-desktop-host
brew install --cask docker
brew install --cask font-hack-nerd-font # used for nerdtree(vim-devicons)
brew install --cask google-chrome
brew install --cask google-japanese-ime
brew install --cask omnigraffle
brew install --cask postman
brew install --cask raycast
brew install --cask slack
brew install --cask spectacle
brew install --cask visual-studio-code

echo "${CYAN}INFO: Installing packages by homebrew...${ESC_END}"
brew tap beeftornado/rmtree
brew tap homebrew/cask
brew tap homebrew/cask-fonts
brew tap homebrew/core
brew tap homebrew/services
brew tap sanemat/font

brew install awscli
brew link --overwrite awscli
brew install bat
brew install composer
brew install docker-compose
mkdir -p ~/.docker/cli-plugins
ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
brew install exa
brew install git
brew install font-hackgen-nerd
brew install jq
brew install nkf
brew install php@8.2
brew services start php@8.2
brew install tfenv
brew install tig
brew install tmux
brew install tree
brew install tty-clock
brew install vim
brew install volta
brew install wget
brew install zsh
brew install zsh-autosuggestions
brew install zsh-completions
brew install zsh-syntax-highlighting

sudo sh -c "echo '/opt/homebrew/bin/zsh' >> /etc/shells"
chsh -s /opt/homebrew/bin/zsh # change shell to zsh
chmod -R go-w /opt/homebrew/share/zsh # Avoid showing warnings

brew bundle --global

echo "${GREEN}INFO: Done brew settings${ESC_END}"
