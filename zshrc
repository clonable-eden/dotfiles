# ~/.zshrc - All interactive shell configuration

# ============================================================
# PATH (WezTerm CLI)
# ============================================================
[[ -d /Applications/WezTerm.app ]] && path=(/Applications/WezTerm.app/Contents/MacOS $path)

# ============================================================
# Plugins (Homebrew)
# ============================================================
if [[ -n $HOMEBREW_PREFIX ]]; then
  fpath=($HOMEBREW_PREFIX/share/zsh-completions $fpath)
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ============================================================
# Tool Hooks
# ============================================================
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"

# ============================================================
# Load split config files (~/.zsh/*.zsh)
# ============================================================
ZSHHOME="${HOME}/.zsh"
if [[ -d $ZSHHOME && -r $ZSHHOME && -x $ZSHHOME ]]; then
  for i in $ZSHHOME/*.zsh(N); do
    [[ -f $i || -h $i ]] && [[ -r $i ]] && source $i
  done
fi
