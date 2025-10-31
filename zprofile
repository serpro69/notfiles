#!/bin/sh
#
# File: .zprofile
# Description:
#   Sets up environment variables and runs commands that should be executed
#   once per login session.
#   This file is loaded once when the user logs in and starts a new shell
#   session.
#   To enable these modifications with an interactive shell, source this file from .zshrc:
#
#     . ~/.zprofile
#
#   NOTE: avoid syntax and commands that are not necessary for login shells.
#   Refer to the 'STARTUP/SHUTDOWN FILES' section of zsh(1) manpage for more information.
#
# NB! Configurable options are set via ~/.dotfiles_config

# Source dotfiles configuration
source ~/.dotfiles_config

# Enable source tracing at TRACE and INFO logging levels
[ "${CONFIG_LOGGING:-OFF}" = "TRACE" ] && [ -n "$ZSH_VERSION" ] && setopt XTRACE
[ "${CONFIG_LOGGING:-OFF}" = "INFO" ] && [ -n "$ZSH_VERSION" ] && setopt SOURCE_TRACE

# Source shellrc which starts the terminal multiplexer
source ~/.redpill/.shellrc

# TODO check and remove
# source $HOME/.redpill/redpill-init-zsh.sh
