.DEFAULT_GOAL := help

.PHONY := help
help: ## makeコマンドのサブコマンドリストと、各コマンドの説明を表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY := all
all: init link brew vim ## Execute all setup commands

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

.PHONY := vim
vim: ## Setup vim
	@.config/vim.sh

.PHONY := b-vsc
b-vsc: ## Update vscode extensions file
	@code --list-extensions > ~/dotfiles/vscode/extensions
