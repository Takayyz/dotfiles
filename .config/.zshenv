#
# Defines environment variables.
#
# Authors: Takayyz
#
export ZDOTDIR=$HOME/.zsh.d

export PATH="$HOME/.local/bin:$PATH"

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
