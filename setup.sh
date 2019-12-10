#!/bin/sh

# Command Line Tools for Xcode
xcode-select --install

# HomeBrew
if [ ! -x "`which brew`" ] ; then
  echo "start install and update brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
  brew upgrade
  brew -v
fi
