#!/bin/bash

source "$(cd "$(dirname "$0")" && pwd)/colors.txt"

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
