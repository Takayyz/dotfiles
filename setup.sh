#!/bin/sh

# ================================================================================
#   Variables
# ================================================================================
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


# ================================================================================
#   Identify MacOS
# ================================================================================
if [ "$(uname)" != "Darwin" ] ; then
  echo "${RED}ERROR: Hmmm, its Not MacOS!${ESC_END}"
  exit 1
fi

echo "${CYAN}Starting setup MacOS!${ESC_END}"

# Command Line Tools for Xcode
if [ ! -x "xcode-select" ]; then
  echo "${CYAN}Installing command line toos for xcode...${ESC_END}"
else
  echo "${YELLOW}NOTICE: command line tools already exists${ESC_END}"
  echo "Updating command line tools..."
  sudo rm -rf /Library/Developer/CommandLineTools
fi
xcode-select --install

# ================================================================================
#   Configure Macbook settings
# ================================================================================
sudo nvram SystemAudioVolume=%80    # ブート時のサウンド無効化

echo "${CYAN}Setup defaults${ESC_END}"
# ---- Language ----
defaults write -g AppleLanguages -array en-US ja   # set OS language to en

# ---- Finder ----
defaults write com.apple.finder QuitMenuItem -bool true   # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"   # Finder: set view as column by default
chflags nohidden ~/Library    # show ~/Library by default
sudo chflags nohidden /Volumes    # show /Volumes by default
defaults write com.apple.finder AppleShowAllFiles -bool true   # Finder: show hidden files by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true   # Finder: show all filename extensions
defaults write com.apple.finder ShowStatusBar -bool true   # Finder: show status bar
defaults write com.apple.finder ShowPathbar -bool true   # Finder: show path bar
defaults write com.apple.finder ShowTabView -bool true   # Finder: show tab bar
# defaults write com.apple.finder QLEnableTextSelection -bool true   # Finder: allow text selection in Quick Look
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true   # Display full POSIX path as Finder window title
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false   # hide icons for external dard drives
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false   # hide icons for hard drives
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false   # hide icons for servers
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false   # hide icons for removable media
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # When performing a search, search the current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false   # Disable the warning when changing a file extension
defaults write NSGlobalDomain com.apple.springing.enabled -bool true   # Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0   # Remove the spring loading delay for directories
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true   # Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true   # Avoid creating .DS_Store files on USB volumes

# ---- Dock and Mission Control----
defaults write com.apple.dock tilesize -int 36   # Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock show-process-indicators -bool true   # Show indicator lights for open applications in the Dock
defaults write com.apple.dock launchanim -bool false   # Don’t animate opening applications from the Dock
defaults write com.apple.dock autohide-delay -float 0   # Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-time-modifier -float 0   # Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide -bool true   # Automatically hide and show the Dock
defaults write com.apple.dock showhidden -bool true   # Make Dock icons of hidden applications translucent
defaults write com.apple.dock expose-group-by-app -bool false   # Don’t group windows by application in Mission Control
defaults write com.apple.dock mru-spaces -bool false   # Don’t automatically rearrange Spaces based on most recent use

# ---- Hot corners ----
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

# ---- Screen ----
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# ---- Screen capture ----
defaults write com.apple.screencapture disable-shadow -bool true   # Disable shadow in screenshots
defaults write com.apple.screencapture location -string "$HOME/Downloads/screenshots"   # Save screenshots to the downloads/screenshots

# ---- Trackpad ----
# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
#Trackpad: adjust tracking speed
defaults write -g com.apple.mouse.scaling 10
defaults write -g com.apple.trackpad.scaling 10
# Trackpad: map click or tap with two-fingers to right-click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0

# ---- Keyboard ----
defaults write -g NSGlobalDomain KeyRepeat -int 2   # Set a blazingly fast keyboard repeat rate
defaults write -g NSGlobalDomain InitialKeyRepeat -int 15   # Set delay until keyboard repeat
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false   # Disable auto-correct

# ---- Menu bar ----
defaults write com.apple.menuextra.battery ShowPercent -string "YES"   #Menu bar: show battery percentage
# Menu bar: show battery, bluetooth, wifi, and clock icons
defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Battery.menu" "/System/Library/CoreServices/Menu Extras/Clock.menu"
defaults write com.apple.menuextra.clock 'DateFormat' -string 'EEE H:mm:ss'   # Date options: Show the day of the week: on

# ---- Others ----
defaults write com.apple.LaunchServices LSQuarantine -bool false   # Disable the “Are you sure you want to open this application?” dialog
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true   # Display ASCII control characters using caret notation in standard text views
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40    # Bluetooth ヘッドフォン・ヘッドセットの音質を向上させる

killall Finder
killall Dock
echo "${GREEN}Done setup defaults${ESC_END}"

# ================================================================================
#   Homebrew
# ================================================================================
# Install Homebrew
if [ ! -x "`which brew`" ] ; then
  echo "${CYAN}Installing homebrew...${ESC_END}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "${CYAN}Updating homebrew${ESC_END}"
brew update
echo "${CYAN}Upgrading homebrew${ESC_END}"
brew upgrade
brew -v

echo "${CYAN}Installing packages with homebrew...${ESC_END}"
# TODO brew install系を別ファイル化(brewfile, brew bundle, gistにアップ?)
brew tap beeftornado/rmtree
brew tap homebrew/cask
brew tap homebrew/cask-fonts
brew tap homebrew/core
brew tap homebrew/services
brew tap sanemat/font
brew tap skanehira/docui

brew install composer
brew install docker-compose
brew install docui
brew install git
brew install jesseduffield/lazygit/lazygit
brew install jq
brew install nkf
brew install nvm
brew install php@7.4
brew install ricty
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf
brew install tree
brew install vim
brew install wget
brew install zsh
brew install zsh-autosuggestions
brew install zsh-completions
brew install zsh-syntax-hilighting
echo '/usr/local/bin/zsh' >> /etc/shells
chsh -s /usr/local/bin/zsh   # change shell to zsh

# echo "${CYAN}Installing Homebrew-cask${ESC_END}"
# brew install cask

echo "${CYAN}Installing applications with Homebrew cask...${ESC_END}"
brew install --cask alfred
brew install --cask appcleaner
brew install --cask clipy
brew install --cask chrome-remote-desktop-host
brew install --cask docker
brew install --cask filezilla
brew install --cask google-chrome
brew install --cask google-japanese-ime
brew install --cask hyper
brew install --cask hyperswitch
brew install --cask iterm2
brew install --cask postman
brew install --cask slack
brew install --cask spectacle
brew install --cask vagrant
brew install --cask vagrant-manager
brew install --cask virtualbox
brew install --cask visual-studio-code

echo "${GREEN}Done brew settings${ESC_END}"

# ================================================================================
# Setup VSCode
# ================================================================================
if [ -x "`which code`" ]; then
  echo "${CYAN}Setup VSCode...${ESC_END}"
  code --install-extension Shan.code-settings-sync -force
  echo "${GREEN}Done${ESC_END}"
fi

# ================================================================================
# Install zprezto
# ================================================================================
echo "${CYAN}Installing and setup zprezto${ESC_END}"
if [ ! -d ~/.zsh.d ] ; then
  mkdir ~/.zsh.d
fi
touch .zshenv
echo -e "export ZDOTDIR=$HOME/.zsh.d" >> .zshenv
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
echo -e "source $ZDOTDIR/.zshenv" >> .zshenv
zsh

# ================================================================================
# Install other apps
# ================================================================================
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

# ================================================================================
#  Create symlink at home directory
#  skip .git
# ================================================================================
echo "${CYAN}Create symlink of dotfiles at home directory${ESC_END}"
PWD = pwd
for f in .??*; do
    [ "$f" = ".git" ] && continue
    [ "$f" = ".gitignore" ] && continue

    # -s create a symlink
    # -f force overwrite
    # -n replace existing symlink
    # -v display progress
    if [[ "$f" = ".z"* ]]; then
      ln -snfv "$PWD/$f" "${ZDOTDIR:-$HOME}/$f"
    elif [[ "$f" = ".vim" ]]; then
      ln -snfv "$PWD/$f/colors/hybrid.vim" "$HOME/$f/colors/hybrid.vim"
    else
      ln -snfv "$PWD/$f" "$HOME/$f"
    fi
done
zsh

# ================================================================================
# Setup iTerm
# ================================================================================

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

Other things that you should do below manually...
------------------------------------------------------------
Turn Spotlight off
------------------------------------------------------------

Enjoy!
EOS

# 参考記事
# http://neos21.hatenablog.com/entry/2019/01/10/080000 (defaultsコマンド)
# https://qiita.com/kai_kou/items/af5d0c81facc1317d836 (setup.shまとめ)
# https://qiita.com/kai_kou/items/3107e0a056c7a1b569cd (環境構築系記事)
# https://qiita.com/hkusu/items/18cbe582abb9d3172019 (Gistについて)
