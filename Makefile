DOTFILES := zshenv zprofile zshrc zlogin
ZSHDIR   := zsh

.PHONY: install uninstall deps undeps

install:
	@for f in $(DOTFILES); do \
		ln -sfnv $(CURDIR)/$$f ~/.$$f; \
	done
	ln -sfnv $(CURDIR)/$(ZSHDIR) ~/.$(ZSHDIR)
	mkdir -p ~/.config/wezterm
	ln -sfnv $(CURDIR)/config/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
	ln -sfnv $(CURDIR)/config/starship.toml ~/.config/starship.toml
	@echo "Done!"

HOMEBREW_PREFIX ?= /opt/homebrew
BREW_FORMULAE  := zsh zsh-completions zsh-syntax-highlighting zoxide mise starship watch
BREW_CASKS     := wezterm font-moralerspace-hw
BREW_ZSH       := $(HOMEBREW_PREFIX)/bin/zsh

deps:
	brew install $(BREW_FORMULAE)
	brew install --cask $(BREW_CASKS)
	@grep -qxF '$(BREW_ZSH)' /etc/shells || { echo "Adding $(BREW_ZSH) to /etc/shells (requires sudo)"; echo '$(BREW_ZSH)' | sudo tee -a /etc/shells; }
	@if [ "$$SHELL" != "$(BREW_ZSH)" ]; then echo "Changing login shell to $(BREW_ZSH)"; chsh -s $(BREW_ZSH); fi

undeps:
	@if [ "$$SHELL" = "$(BREW_ZSH)" ]; then echo "Changing login shell back to /bin/zsh"; chsh -s /bin/zsh; fi
	@grep -qxF '$(BREW_ZSH)' /etc/shells && { echo "Removing $(BREW_ZSH) from /etc/shells (requires sudo)"; sudo sed -i '' '\|^$(BREW_ZSH)$$|d' /etc/shells; } || true
	brew uninstall $(BREW_FORMULAE)
	brew uninstall --cask $(BREW_CASKS)

uninstall:
	@for f in $(DOTFILES); do \
		rm -fv ~/.$$f; \
	done
	rm -fv ~/.$(ZSHDIR)
	rm -fv ~/.config/wezterm/wezterm.lua
	rm -fv ~/.config/starship.toml
	@echo "Done!"
