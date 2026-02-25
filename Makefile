.DEFAULT_GOAL := help

.PHONY := help
help: ## makeコマンドのサブコマンドリストと、各コマンドの説明を表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY := all
all: ## Execute all setup commands
	@make init
	@make link
	@make defaults
	@make brew
	@make volta
	@make zsh
	@make gh
	@echo Congrats!! You are all set!

.PHONY := init
init: ## Set initial preference
	@.config/init.sh

.PHONY := link
link: ## Link dotfiles
	@.config/link.sh

.PHONY := defaults
defaults: ## Set macOS system preferences
	@.config/defaults.sh

.PHONY := brew
brew: ## Install macOS applications
	@.config/brew.sh

.PHONY := volta
volta: ## Install Node.js toolchain via Volta
	@.config/volta.sh

.PHONY := zsh
zsh: ## Setup vim
	@.config/zsh.sh

.PHONY := gh
gh: ## Install gh CLI extensions
	@.config/gh.sh

.PHONY := b-vsc
b-vsc: ## Update vscode extensions file
	@code --list-extensions > ~/dotfiles/vscode/extensions

.PHONY := b-gh
b-gh: ## Update gh extensions file
	@gh extension list | awk '{print $$2}' > .config/gh/extensions
