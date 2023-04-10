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

if [ -d $HOME/.redpill ]; then

  # Path to oh-my-zsh configuration.
  export ZSH="$HOME/.redpill/ohmyzsh"
  ZSH_CUSTOM="$HOME/.redpill/bluepill"

  # TODO check and remove
  # source $HOME/.redpill/redpill-init-zsh.sh
fi

# TODO this shouldn't be here
# Added by Toolbox App
export PATH="$PATH:/home/sergio/.local/share/JetBrains/Toolbox/scripts"
