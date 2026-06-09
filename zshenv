# ~/.zshenv - Loaded by all zsh instances (including scripts)
# Rule: export env vars only. No command execution (slows startup).

# Locale
export LANG=ja_JP.UTF-8

# Editor
export EDITOR=vim

# PATH deduplication (actual PATH additions live in zprofile/zshrc
# because macOS /etc/zprofile runs path_helper, which reorders entries
# set here to the end.)
typeset -U path
