########################################
# Aliases

alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# Enable alias expansion after sudo
alias sudo='sudo '

# Global aliases
alias -g L='| less'
alias -g G='| grep'

# Pipe stdout to clipboard with C
(( $+commands[pbcopy] )) && alias -g C='| pbcopy'

########################################
# macOS settings
export CLICOLOR=1
alias ls='ls -G -F'
