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
echo "${CYAN}INFO: Installing Xcode...${ESC_END}"
xcode-select --install > /dev/null
