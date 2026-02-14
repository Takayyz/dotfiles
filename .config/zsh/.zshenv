#
# Defines environment variables.
#
# Authors: Takayyz
#
export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Rust
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
