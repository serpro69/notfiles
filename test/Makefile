.DEFAULT_GOAL := help

.PHONY: vagrant_up
vagrant_up: ## Starts and provisions the vagrant environment
	vagrant up
	vagrant scp ../../dotfiles default:/home/vagrant/

.PHONY: vagrant_rebuild
vagrant_rebuild: ## Destroys the existing vagrant environments and provisions a new one
	vagrant destroy -f
	$(MAKE) vagrant_up

.PHONY: help
help: ## Displays this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

