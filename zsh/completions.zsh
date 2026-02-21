########################################
# Completion

# fpath (Docker CLI completions)
[[ -d $HOME/.docker/completions ]] && fpath=($HOME/.docker/completions $fpath)

# Initialize completion system
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Don't complete current directory after ../
zstyle ':completion:*' ignore-parents parent pwd ..

# Complete command names after sudo
zstyle ':completion:*:sudo:*' command-path /opt/homebrew/sbin /opt/homebrew/bin \
                   /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# Process name completion for ps
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
