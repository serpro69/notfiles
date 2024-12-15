#!/bin/sh
#
# File: .zshrc
# Description:
#   Sets up interactive shell configuration, aliases, and functions.
#   This file is loaded every time a new interactive shell is started, so it
#   should be kept as lightweight as possible.
#   To enable these modifications, source this file from .zshenv or .zprofile:
#
#     . ~/.zshrc
#
#   NOTE: avoid syntax and commands that are not necessary for interactive use.
#   Refer to the 'STARTUP/SHUTDOWN FILES' section of zsh(1) manpage for more information.

# Path to oh-my-zsh configuration.
export ZSH="$HOME/.redpill/ohmyzsh"
ZSH_CUSTOM="$HOME/.redpill/bluepill"

# Source the zprofile in case we want to update dotfiles configuration dynamically and it's not a login shell
[[ -o login ]] || source ~/.redpill/.zprofile

# Theme settings
[[ -z "$CONFIG_ZSH_THEME" ]] && CONFIG_ZSH_THEME="random"
# Set name of the theme to load.
# Look in ~/.redpill/ohmyzsh/themes
# Custom themes are in ~/.redpill/bluepill/themes
# Optionally, if you set this to "random", it'll load a random theme each time that you enter the matrix.
ZSH_THEME="$CONFIG_ZSH_THEME"

# Auto update settings
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Don't resolve symbolic links in z
_Z_NO_RESOLVE_SYMLINKS="true"

# Colorize settings
ZSH_COLORIZE_TOOL=chroma
# Nice ones: arduino friendly paraiso-dark solarized-dark solarized-dark256 vim
ZSH_COLORIZE_STYLE=vim

# Add plugins from the command line
[[ -z "$add_plugins" ]] || read -A add_plugins <<< "$add_plugins"

# Which plugins would you like to load? (plugins can be found in ~/.redpill/plugins/*)
# Custom plugins may be added to ~/.redpill/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=($(echo $CONFIG_ZSH_PLUGINS | sed 's/(//g' | sed 's/)//g') ${add_plugins})
unset add_plugins

# source plugin settings before loading oh-my-zsh
source "$ZDOTDIR/plugins"

# Don't load Oh My Zsh on TTYs
[[ -z "$OMZ_LOAD" && $TTY = /dev/tty* && $(uname -a) != ([Dd]arwin*|[Mm]icrosoft*) ]] \
  || source "$ZSH/oh-my-zsh.sh"

## User configuration

ZSH_THEME_TERM_TAB_TITLE_IDLE="%~"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#767676,underline"

# add shell level information to prompt for when dealing with nested zsh sessions
RPROMPT+="${RPROMPT+ }%(2L.{%F{yellow}%L%f}.)"
ZLE_RPROMPT_INDENT=$(( SHLVL > 1 ? 0 : ZLE_RPROMPT_INDENT ))

# add color to correct prompt
SPROMPT="Correct '%F{red}%R%f' to '%F{green}%r%f' [nyae]? "

# enable color support
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.redpill/dircolors && eval "$(dircolors -b ~/.redpill/dircolors)" || eval "$(dircolors -b)"

  # ls completion dir_colors
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# complete . and .. directories
zstyle ':completion:*' special-dirs true

# paginated completion
zstyle ':completion:*' list-prompt   ''
zstyle ':completion:*' select-prompt ''

# Docker completion option stacking
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# correct behaviour when specifying commit parent (commit^)
alias git='noglob git'

# prevent adding files as key strokes when using bindkey
alias bindkey='noglob bindkey'

## Key bindings
bindkey '^U' kill-buffer        # delete whole buffer
bindkey '^[i' undo              # ALT + i more accessible Undo
bindkey '^[[3;3~' kill-word     # ALT + DEL deletes whole forward-word
bindkey '^H' backward-kill-word # CTRL + BACKSPACE deletes whole backward-word
bindkey '^[l' down-case-word    # ALT + L lowercases word

# beginning history search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# insert all matches
zle -C all-matches complete-word _generic
bindkey '^Xa' all-matches
zstyle ':completion:all-matches:*' insert yes
zstyle ':completion:all-matches::::' completer _all_matches _complete

## More zsh options
setopt correct        # correction of commands
setopt extended_glob  # adds ^ and other symbols as wildcards
setopt share_history  # i want all typed commands to be available everywhere

# zmv (mass mv / cp / ln)
autoload zmv
alias mmv='noglob zmv -W -v'

# zed (zsh editor)
autoload -Uz zed

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

## Sourcing external files
# * ~/.extra can be used for other settings you don’t want to commit.
#for file in ~/.{dotfiles_config,path,load,exports,colors,icons,aliases,functions,extra}; do
for file in ~/.redpill/{aliases,exports,extra,functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Workaround for https://github.com/ohmyzsh/ohmyzsh/issues/10156
autoload +X -Uz _git && _git &>/dev/null
functions[_git-stash]=${functions[_git-stash]//\\_git-notes /}

# add current directory to the end of PATH
path+=(.)

# Load per-host zshrc overriding files
for file in "$ZDOTDIR"/.zshrc.^(bck|new)(N); do source "$file"; done; unset file

# Custom Hooks

# completions for tools installed via brew
[ -n "$ZSH_VERSION" ] && type brew &>/dev/null && {
  # case sensitive completions in omz
  # https://github.com/ohmyzsh/ohmyzsh/blob/69a6359f7cf8978d464573fb7b023ee3cd00181a/lib/completion.zsh#L17-L19
  export CASE_SENSITIVE="true"
  fpath+=("$(brew --prefix)/share/zsh/site-functions")
  typeset -U path
  typeset -U fpath
  autoload -Uz compinit && compinit
}

# creds: https://unix.stackexchange.com/a/553229
# excludes certain commands from being added to history
zshaddhistory() {
  local full_cmd=$1
  full_cmd="${full_cmd#"${full_cmd%%[![:space:]]*}"}"  # Trim leading spaces
  full_cmd="${full_cmd%"${full_cmd##*[![:space:]]}"}"  # Trim trailing spaces
  local cmd="${1%% *}"
  cmd="${cmd#"${cmd%%[![:space:]]*}"}"  # Trim leading spaces
  cmd="${cmd%"${cmd##*[![:space:]]}"}"  # Trim trailing spaces
  # notify-send "'${full_cmd}'" "'${cmd}'" # debugging
  case ${cmd} in
    (vi|vim|nvim) return 1;;
  esac
  case ${full_cmd} in
    (git st|git diff|git push|git lg) return 1;;
  esac
  return 0
}
