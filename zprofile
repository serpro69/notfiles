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

  if [[ -z "$CONFIG_ZSH_THEME" ]]; then
    CONFIG_ZSH_THEME="random"
  fi

  # Set name of the theme to load.
  # Look in ~/.redpill/ohmyzsh/themes
  # Custom themes are in ~/.redpill/bluepill/themes
  # Optionally, if you set this to "random", it'll load a random theme each time that you enter the matrix.
  ZSH_THEME="$CONFIG_ZSH_THEME"

  # Add plugins from the command line
  [[ -z "$add_plugins" ]] || read -A add_plugins <<< "$add_plugins"

  # Which plugins would you like to load? (plugins can be found in ~/.redpill/plugins/*)
  # Custom plugins may be added to ~/.redpill/custom/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.
  plugins=($(echo $CONFIG_ZSH_PLUGINS | sed 's/(//g' | sed 's/)//g') $add_plugins)
  unset add_plugins

  # TODO check and remove
  # source $HOME/.redpill/redpill-init-zsh.sh
fi

# TODO this shouldn't be here
# Added by Toolbox App
export PATH="$PATH:/home/sergio/.local/share/JetBrains/Toolbox/scripts"
