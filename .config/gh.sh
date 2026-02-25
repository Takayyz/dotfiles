#!/bin/bash

source "$(cd "$(dirname "$0")" && pwd)/colors.txt"

EXTENSIONS_FILE="$(cd "$(dirname "$0")" && pwd)/gh/extensions"

if [ ! -x "$(which gh)" ] ; then
  echo "${RED}ERROR: gh is not installed. Run 'make brew' first.${ESC_END}"
  exit 1
fi

if [ ! -f "$EXTENSIONS_FILE" ] ; then
  echo "${RED}ERROR: extensions file not found at ${EXTENSIONS_FILE}${ESC_END}"
  exit 1
fi

echo "${CYAN}INFO: Installing gh extensions...${ESC_END}"

# Get currently installed extensions (owner/repo format)
installed=$(gh extension list | awk '{print $2}')

while IFS= read -r line || [ -n "$line" ]; do
  # Skip empty lines and comments
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

  if echo "$installed" | grep -qx "$line"; then
    echo "${YELLOW}NOTICE: ${line} already installed, upgrading...${ESC_END}"
    gh extension upgrade "$line"
  else
    echo "${CYAN}INFO: Installing ${line}...${ESC_END}"
    gh extension install "$line"
  fi
done < "$EXTENSIONS_FILE"

echo "${GREEN}INFO: Done gh extension settings${ESC_END}"
