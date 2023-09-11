#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VSCODE_SET_DIR="${HOME}/Library/Application Support/Code/User"

source ${SCRIPT_DIR}/colors.txt

echo "${CYAN}INFO: Setup VSCode...${ESC_END}"

# Link settings.json (-L: ファイルが存在するかつシンボリックならtrue)
if [ -L "${VSCODE_SET_DIR}/settings.json" ]; then
  ln -fsvn "${SCRIPT_DIR}/settings.json" "${VSCODE_SET_DIR}/settings.json"
fi

# Install extensions using the code command
if [ "$(which code)" != "" ]; then
  cat < "${SCRIPT_DIR}/extensions" | while read -r line
  do
    code --install-extension "$line"
  done
  echo "${GREEN}INFO: Done${ESC_END}"
else
  echo "${YELLOW}NOTICE: Install the code command from the command palette to add your extensions.${ESC_END}"
fi
