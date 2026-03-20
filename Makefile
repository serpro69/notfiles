.POSIX:
.ONESHELL:
.SHELL      := $(shell which bash)
.SHELLFLAGS := -ec

.PHONY: help fix-spaceship-async

default: help

help: ## Print this help message
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

fix-spaceship-async: ## Add sleep 0.1 to spaceship-prompt async.zsh
	@# only a problem on linux
	if [ ! $$(uname) = Darwin ]; then
	    sed -i 's/\(setopt localoptions noxtrace\)/\1\n\n  sleep 0.1/' ./bluepill/themes/spaceship-prompt/async.zsh
	fi
