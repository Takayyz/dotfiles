#!/bin/bash

source "$(cd "$(dirname "$0")" && pwd)/colors.txt"

VOLTAFILE="$(cd "$(dirname "$0")" && pwd)/.Voltafile"

if [ "$(uname)" != "Darwin" ] ; then
  echo "${RED}ERROR: Hmmm, it's not macOS...${ESC_END}"
  exit 1
fi

if [ ! -x "$(which volta)" ] ; then
  echo "${RED}ERROR: Volta is not installed. Run 'make brew' first.${ESC_END}"
  exit 1
fi

if [ ! -f "$VOLTAFILE" ] ; then
  echo "${RED}ERROR: .Voltafile not found at ${VOLTAFILE}${ESC_END}"
  exit 1
fi

echo "${CYAN}INFO: Installing Volta packages from .Voltafile...${ESC_END}"

while IFS= read -r line || [ -n "$line" ]; do
  # Skip empty lines and comments
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

  # Parse: type "name" ["version"]
  type=$(echo "$line" | awk '{print $1}')
  name=$(echo "$line" | awk -F'"' '{print $2}')
  version=$(echo "$line" | awk -F'"' '{print $4}')

  case "$type" in
    runtime|manager|package)
      if [ -n "$version" ]; then
        echo "${CYAN}INFO: Installing ${type}: ${name}@${version}${ESC_END}"
        volta install "${name}@${version}"
      else
        echo "${CYAN}INFO: Installing ${type}: ${name}@latest${ESC_END}"
        volta install "${name}"
      fi
      ;;
    *)
      echo "${YELLOW}WARN: Unknown type '${type}' — skipping: ${line}${ESC_END}"
      ;;
  esac
done < "$VOLTAFILE"

echo "${GREEN}INFO: Done Volta settings${ESC_END}"
