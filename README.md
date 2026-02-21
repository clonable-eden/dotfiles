# dotfiles

Personal dotfiles for macOS — zsh, WezTerm, Starship, and more.

## Structure

```
dotfiles/
├── zshenv              # env vars (all zsh instances)
├── zprofile            # login shell (Homebrew)
├── zshrc               # interactive shell (plugins, tools)
├── zlogin
├── zsh/
│   ├── base.zsh        # key bindings, history, word style
│   ├── option.zsh      # shell options
│   ├── alias.zsh       # aliases, macOS settings
│   └── completions.zsh # completion, syntax highlighting
├── config/
│   ├── starship.toml   # Starship prompt config
│   └── wezterm/
│       └── wezterm.lua # WezTerm terminal config
└── Makefile
```

## Setup

```sh
git clone <repo-url> ~/git/clonable-eden/dotfiles
cd ~/git/clonable-eden/dotfiles
make install   # create symlinks
make deps      # install Homebrew formulae and zsh plugins
```

## Uninstall

```sh
make uninstall   # remove symlinks
make undeps      # uninstall Homebrew formulae, casks, and zsh plugins
```

## Dependencies

Installed automatically via `make deps`:

Homebrew formulae:

- [zsh](https://www.zsh.org/) — latest zsh
- [zplug](https://github.com/zplug/zplug) — plugin manager
- [zoxide](https://github.com/ajeetdsouza/zoxide) — smarter cd
- [mise](https://mise.jdx.dev/) — runtime version manager
- [starship](https://starship.rs/) — cross-shell prompt

Homebrew casks:

- [WezTerm](https://wezfurlong.org/wezterm/) — terminal emulator
- [Moralerspace HW](https://github.com/yuru7/moralerspace) — font

zplug:

- [zsh-completions](https://github.com/zsh-users/zsh-completions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

Manual install required:

- [Homebrew](https://brew.sh/) — prerequisite
