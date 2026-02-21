# ~/.zshrc - All interactive shell configuration

# ============================================================
# PATH (WezTerm CLI)
# ============================================================
[[ -d /Applications/WezTerm.app ]] && path=(/Applications/WezTerm.app/Contents/MacOS $path)

# ============================================================
# Plugin Manager (zplug)
# ============================================================
ZPLUG_HOME=$HOMEBREW_PREFIX/opt/zplug
if [[ -f $ZPLUG_HOME/init.zsh ]]; then
  source $ZPLUG_HOME/init.zsh
  zplug 'zsh-users/zsh-completions', use:'src/_*', lazy:true
  zplug 'zsh-users/zsh-syntax-highlighting', defer:2
  zplug load
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
