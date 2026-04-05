# ~/.zprofile - Runs only in login shells (e.g. macOS terminal launch)
# Rule: one-time setup such as PATH initialization

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || eval "$(/usr/local/bin/brew shellenv 2>/dev/null)"

# Homebrew keg-only packages (not symlinked into HOMEBREW_PREFIX)
path=($HOMEBREW_PREFIX/opt/sqlite/bin $path)
