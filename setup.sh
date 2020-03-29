#!/bin/sh

# ================================================================================
#   Identify MacOs
# ================================================================================

if [ "$(uname)" != "Darwin" ] ; then
  echo 'Hmmm, its Not MacOS!'
  exit 1
fi

echo 'Start setup MacOS!'

# Command Line Tools for Xcode
xcode-select --install

# ================================================================================
#   Configure Macbook settings
# ================================================================================
# TODO turn spotlight shortcut off

sudo nvram SystemAudioVolume=" "    # ブート時のサウンド無効化

echo 'Setup defaults'
# ---- Language ----
defaults write -g AppleLanguages -array en ja   # set language to en

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

echo 'Done setup defaults'

# ================================================================================
#   Homebrew
# ================================================================================
# Install Homebrew
if [ ! -x "`which brew`" ] ; then
  echo "Start install and update brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo 'Update brew'
  brew update
  echo 'Upgrade brew'
  brew upgrade
  brew -v
  echo 'Done'
fi

echo 'Install packages with brew'
# TODO brew install系を別ファイル化(brewfile, brew bundle, gistにアップ?)
brew install docker-compose
brew install docui
brew install git
brew install jq
brew install lazygit
brew install nkf
brew install php@7.4
brew install ricty
brew install tree
brew install vim
brew install wget
brew install zsh


echo 'Install Homebrew-cask'
brew install cask
brew cask

echo 'Install applications with Homebrew-cask'
brew cask install alfred
brew cask install appcleaner
brew cask install clipy
brew cask install docker
brew cask install filezilla
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install hyper
brew cask install iterm2
brew cask install postman
brew cask install slack
brew cask install spectacle
brew cask install vagrant
brew cask install vagrant-manager
brew cask install virtualbox
brew cask install visual-studio-code

echo 'Done brew settings'

# ================================================================================
# Setup VSCode
# ================================================================================
# if [ -x "`which code`" ]; then
#   echo 'Setup VSCode'
#   code --install-extension Shan.code-settings-sync -force
#   echo "done"
# fi

# ================================================================================
# Setup iTerm
# ================================================================================



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
echo 'Create symlink of dotfiles at home directory'
for f in .??*
do
    [ "$f" = ".git" ] && continue

    # -s create a symlink
    # -f force overwrite
    # -n replace existing symlink
    # -v display progress
    ln -snfv "$f" "$HOME"/"$f"
done

cat << EOS
Congrats!! You are all set!
Before close this window, run command below...
--------------------
which git
which php
which zsh

git config --global user.name "username"
git config --global user.mail "your.email@address"
--------------------

Enjoy!
EOS

# 参考記事
# http://neos21.hatenablog.com/entry/2019/01/10/080000 (defaultsコマンド)
# https://qiita.com/kai_kou/items/af5d0c81facc1317d836 (setup.shまとめ)
# https://qiita.com/kai_kou/items/3107e0a056c7a1b569cd (環境構築系記事)
# https://qiita.com/hkusu/items/18cbe582abb9d3172019 (Gistについて)
