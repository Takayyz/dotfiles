#!/bin/bash

source "$(cd "$(dirname "$0")" && pwd)/colors.txt"

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
if [ ! -d "${HOME}/Downloads/screenshots" ]; then
	mkdir "${HOME}/Downloads/screenshots"
fi
defaults write com.apple.screencapture location -string "${HOME}/Downloads/screenshots"   # Save screenshots to the downloads/screenshots

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
