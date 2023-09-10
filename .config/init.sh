#!/bin/bash

# --------------------------------------------------------------------------------
#   Variables
# --------------------------------------------------------------------------------
ESC=$(printf '\033') ESC_END="${ESC}[m" RESET="${ESC}[0m"

BOLD="${ESC}[1m"        FAINT="${ESC}[2m"       ITALIC="${ESC}[3m"
UNDERLINE="${ESC}[4m"   BLINK="${ESC}[5m"       FAST_BLINK="${ESC}[6m"
REVERSE="${ESC}[7m"     CONCEAL="${ESC}[8m"     STRIKE="${ESC}[9m"

GOTHIC="${ESC}[20m"     DOUBLE_UNDERLINE="${ESC}[21m" NORMAL="${ESC}[22m"
NO_ITALIC="${ESC}[23m"  NO_UNDERLINE="${ESC}[24m"     NO_BLINK="${ESC}[25m"
NO_REVERSE="${ESC}[27m" NO_CONCEAL="${ESC}[28m"       NO_STRIKE="${ESC}[29m"

BLACK="${ESC}[30m"      RED="${ESC}[31m"        GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"     BLUE="${ESC}[34m"       MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m"       WHITE="${ESC}[37m"      DEFAULT="${ESC}[39m"

BG_BLACK="${ESC}[40m"   BG_RED="${ESC}[41m"     BG_GREEN="${ESC}[42m"
BG_YELLOW="${ESC}[43m"  BG_BLUE="${ESC}[44m"    BG_MAGENTA="${ESC}[45m"
BG_CYAN="${ESC}[46m"    BG_WHITE="${ESC}[47m"   BG_DEFAULT="${ESC}[49m"


# --------------------------------------------------------------------------------
#   Identify macOS
# --------------------------------------------------------------------------------
if [ "$(uname)" != "Darwin" ] ; then
  echo "${RED}ERROR: Hmmm, it's not macOS...${ESC_END}"
  exit 1
fi

echo "${CYAN}INFO: Starting setup macOS${ESC_END}"

# --------------------------------------------------------------------------------
#   Install Xcode
# --------------------------------------------------------------------------------

# Command Line Tools for Xcode
xcode-select -v &> /dev/null
if [ $? -ne 0 ]; then
  echo "${CYAN}INFO: Installing Xcode...${ESC_END}"
else
  echo "${YELLOW}NOTICE: Xcode already exists${ESC_END}"
  echo "INFO: Reinstalling Xcode..."
  sudo rm -rf /Library/Developer/CommandLineTools
fi
xcode-select --install

# --------------------------------------------------------------------------------
#   Configure Macbook settings
# --------------------------------------------------------------------------------
sudo nvram SystemAudioVolume=%80    # ブート時のサウンド無効化

echo "${CYAN}INFO: Setup defaults${ESC_END}"
# ========= Language ==========
defaults write -g AppleLanguages -array en ja   # set OS language to en

# ========== Appreance ==========
# - Dark
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
# defaults delete .GlobalPreferences AppleInterfaceStyleSwitchesAutomatically > /dev/null 2>&1
# defaults write .GlobalPreferences AppleInterfaceStyle -string "Dark"

# ========== Finder ==========
sudo chflags nohidden /Volumes    # show /Volumes by default
defaults write -g AppleShowAllExtensions -bool true   # Finder: show all filename extensions
defaults write com.apple.finder AppleShowAllFiles -bool true   # Finder: show hidden files by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # When performing a search, search the current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false   # Disable the warning when changing a file extension
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # Finder: set view as column by default
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true   # Display full POSIX path as Finder window title
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false   # hide icons for external dard drives
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false   # hide icons for hard drives
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false   # hide icons for servers
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false   # hide icons for removable media
defaults write com.apple.finder ShowStatusBar -bool true   # Finder: show status bar
defaults write com.apple.finder ShowPathbar -bool true   # Finder: show path bar
defaults write com.apple.finder ShowTabView -bool true   # Finder: show tab bar
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true   # Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true   # Avoid creating .DS_Store files on USB volumes

# ========== Dock and Mission Control ==========
defaults write com.apple.dock autohide -bool true   # Automatically hide and show the Dock
defaults write com.apple.dock autohide-delay -float 0   # Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-time-modifier -float 0   # Remove the animation when hiding/showing the Dock
defaults write com.apple.dock expose-group-by-app -bool false   # Don’t group windows by application in Mission Control
defaults write com.apple.dock launchanim -bool false   # Don’t animate opening applications from the Dock
defaults write com.apple.dock mru-spaces -bool false   # Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock show-process-indicators -bool true   # Show indicator lights for open applications in the Dock
defaults write com.apple.dock showhidden -bool true   # Make Dock icons of hidden applications translucent
defaults write com.apple.dock tilesize -int 36   # Set the icon size of Dock items to 36 pixels

# ========== Hot corners ==========
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Bottom left screen corner → Put display to sleep
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

# ========== Screen ==========
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0

# ========== Screen capture ==========
defaults write com.apple.screencapture disable-shadow -bool true   # Disable shadow in screenshots
if [ ! -d "$HOME/Downloads/screenshots" ]; then
	mkdir "$HOME/Downloads/screenshots"
fi
defaults write com.apple.screencapture location -string "$HOME/Downloads/screenshots"   # Save screenshots to the downloads/screenshots

# ========== Trackpad ==========
# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
#Trackpad: adjust tracking speed
defaults write -g com.apple.trackpad.scaling 10
# Trackpad: map click or tap with two-fingers to right-click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0

# ========== Keyboard ===========
defaults write -g NSGlobalDomain KeyRepeat -int 2   # Set a blazingly fast keyboard repeat rate
defaults write -g NSGlobalDomain InitialKeyRepeat -int 15   # Set delay until keyboard repeat
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false   # Disable auto-correct

# ========== Menu bar ==========
defaults write com.apple.menuextra.battery ShowPercent -string "YES"   #Menu bar: show battery percentage
# Menu bar: show battery, bluetooth, wifi, and clock icons
defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Battery.menu" "/System/Library/CoreServices/Menu Extras/Clock.menu"
defaults write com.apple.menuextra.clock 'DateFormat' -string 'EEE H:mm:ss'   # Date options: Show the day of the week: on

# ========== Others ==========
defaults write com.apple.LaunchServices LSQuarantine -bool false   # Disable the “Are you sure you want to open this application?” dialog
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true   # Display ASCII control characters using caret notation in standard text views
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40    # Bluetooth ヘッドフォン・ヘッドセットの音質を向上させる

killall Finder
killall Dock
echo "${GREEN}INFO: Done setup defaults${ESC_END}"

# --------------------------------------------------------------------------------
#   Homebrew
# --------------------------------------------------------------------------------
# ========== Install Homebrew ==========
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
brew install --cask clipy
brew install --cask chrome-remote-desktop-host
brew install --cask docker
brew install --cask filezilla
brew install --cask font-hack-nerd-font # used for nerdtree(vim-devicons)
brew install --cask google-chrome
brew install --cask google-japanese-ime
brew install --cask hyper
brew install --cask iterm2
brew install --cask omnigraffle
brew install --cask postman
brew install --cask slack
brew install --cask spectacle
brew install --cask tmux
brew install --cask vagrant
brew install --cask vagrant-manager
brew install --cask virtualbox
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
brew install tree
brew install tty-clock
brew install vim
brew install volta
brew install wget
brew install zsh
brew install zsh-autosuggestions
brew install zsh-completions
brew install zsh-syntax-highlighting

sudo echo '/opt/homebrew/bin/zsh' >> /etc/shells
chsh -s /opt/homebrew/bin/zsh # change shell to zsh
chmod -R go-w /opt/homebrew/share/zsh # Avoid showing warnings

echo "${GREEN}INFO: Done brew settings${ESC_END}"

# --------------------------------------------------------------------------------
# Setup VSCode
# --------------------------------------------------------------------------------
if [ -x "`which code`" ]; then
  echo "${CYAN}INFO: Setup VSCode...${ESC_END}"
  code --install-extension Shan.code-settings-sync -r
  echo "${GREEN}INFO: Done${ESC_END}"
fi

# --------------------------------------------------------------------------------
#  Create symlink at home directory
#  skip .git
# --------------------------------------------------------------------------------
echo "${CYAN}INFO: Creating symlink of dotfiles to home directory${ESC_END}"
if [ ! -d "$HOME/.zsh.d" ] ; then
  mkdir "$HOME/.zsh.d"
fi

PWD=$(pwd)
ZDOTDIR=$HOME/.zsh.d
for f in .??*; do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".gitignore" ] && continue

    # -s create a symlink
    # -f force overwrite
    # -n replace existing symlink
    # -v display progress
		if [[ "$f" = ".zshenv" ]]; then
			ln -snfv "$PWD/$f" "$HOME/$f"
    elif [[ "$f" = ".z"* ]]; then
      ln -snfv "$PWD/$f" "${ZDOTDIR:-$HOME}/$f"
    else
      ln -snfv "$PWD/$f" "$HOME/$f"
    fi
done

# --------------------------------------------------------------------------------
# Setup vim
# --------------------------------------------------------------------------------
echo "${CYAN}INFO: Installing Vundle and plugins${ESC_END}"
# if [ ! -d ~/.vim/bundle ] ; then
#   mkdir -p ~/.vim/bundle/Vundle.vim
# fi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
echo "${GREEN}INFO: Done${ESC_END}"

# --------------------------------------------------------------------------------
# Setup nvm
# --------------------------------------------------------------------------------
if [ ! -d "$HOME/.nvm" ] ; then
  mkdir $HOME/.nvm
fi

# --------------------------------------------------------------------------------
# Install zprezto
# --------------------------------------------------------------------------------
echo "${CYAN}INFO: Installing and setup zprezto...${ESC_END}"
source $HOME/.zshenv
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# --------------------------------------------------------------------------------
# Install other apps
# --------------------------------------------------------------------------------
# if [  -x "`which wget`" ]; then
#   echo 'Install other Apps'
#   if [ ! -e "/Applications/forghetti.app" ]; then
#     # Forghetti
#     wget https://downloads.forghetti.com/Forghetti.dmg -O ~/Downloads/Forghetti.dmg
#     hdiutil mount ~/Downloads/Forghetti.dmg
#     cd /Volumes/forghetti\ 1.0.6/
#     cp -r forghetti.app /Applications/
#     cd ~/
#     hdiutil detach /Volumes/forghetti\ 1.0.6/
#   fi
#   echo 'done'
# fi

cat << EOS
Congrats!! You are all set!
Before close this window, run command below...
------------------------------------------------------------
which git
which php
which zsh
------------------------------------------------------------

Also don't forget to setup git config...
------------------------------------------------------------
git config --global user.name "username"
git config --global user.mail "your.email@address"
------------------------------------------------------------

Other things that you should do manually are below...
------------------------------------------------------------
Turn Spotlight off
Launch iTerm2 and apply preferences source directory from 'Prefernces > General > Prefernces'
  *source directory should be '/path/to/homedirectory/dotofiles/iterm2'
------------------------------------------------------------

Enjoy!
EOS

source $ZDOTDIR/.zshrc

# TODO
# - 関数化
# - brew install系を別ファイル化(brewfile, brew bundle, gistにアップ?)
# - shell lint check (https://github.com/rtakasuke/.dotfiles/blob/9524a89ef4a42e30a8a0823a82631390c5232d9c/.github/workflows/lint.yml)

# 参考記事
# http://neos21.hatenablog.com/entry/2019/01/10/080000 (defaultsコマンド)
# https://qiita.com/kai_kou/items/af5d0c81facc1317d836 (setup.shまとめ)
# https://qiita.com/kai_kou/items/3107e0a056c7a1b569cd (環境構築系記事)
# https://qiita.com/hkusu/items/18cbe582abb9d3172019 (Gistについて)
# https://github.com/ulwlu/dotfiles/blob/master/system/macos.sh (defauls一覧)
