# ~/.zshenv - Loaded by all zsh instances (including scripts)
# Rule: export env vars only. No command execution (slows startup).

# Locale
export LANG=ja_JP.UTF-8

# Editor
export EDITOR=vim

# PATH
typeset -U path  # deduplicate
path=(
  $HOME/bin
  $path
)
