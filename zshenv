#!/bin/sh
#
# vim: set ft=sh:
#
# File: .zshenv
# Description:
#   Dynamically sets the PATH at each shell startup, as well as other
#   environment variables.
#   To enable these modifications at logon, source this file from .profile:
#
#     . ~/.zshenv
#
#   NOTE: avoid syntax and commands that aren't portable to other platforms and
#   shells. Check out http://hyperpolyglot.org/unix-shells for more information.

[ ! -t 0 ] || [ -z "$ZSH_VERSION" ] || {
  function echo-off {
    {
      autoload -Uz add-zsh-hook
      stty_bck=$(stty --save)     # back up stty settings
      stty -echo                  # disable echo
      add-zsh-hook precmd echo-on # make sure echo-on next time the prompt is shown
      unfunction $0               # delete function
    } 2>/dev/null
  }
  function echo-on {
    {
      autoload -Uz add-zsh-hook
      [[ -z "$stty_bck" ]] || stty "$stty_bck"  # restore stty settings
      unset stty_bck                            # delete stty backup variable
      add-zsh-hook -d precmd echo-on            # remove echo-on from precmd hook
      unfunction echo-on                        # delete function
    } 2>/dev/null
  }
  echo-off
}

_RED='\033[31m'
_GREEN='\033[32m'
_YELLOW='\033[33m'
_BLUE='\033[34m'
_BOLD='\033[1m'
_RESET='\033[0m'

# Helper function to remove one or more path components from a PATH string.
_remove_path_entry() {
  entries_to_remove_str="$1"
  current_path_input="$2"
  new_path_intermediate="$current_path_input"

  single_entry_to_remove
  # Append a colon to entries_to_remove_str if it's not empty, to simplify loop logic
  remaining_entries_to_remove="${entries_to_remove_str:+$entries_to_remove_str:}"

  while [ -n "$remaining_entries_to_remove" ]; do
    single_entry_to_remove="${remaining_entries_to_remove%%:*}" # Get part before first colon
    remaining_entries_to_remove="${remaining_entries_to_remove#*:}" # Get part after first colon

    if [ -z "$single_entry_to_remove" ]; then
      continue
    fi

    temp_path_after_single_removal=""
    current_path_segment=""
    # Append a colon to new_path_intermediate if it's not empty, to simplify loop logic
    remaining_path_segments="${new_path_intermediate:+$new_path_intermediate:}"

    while [ -n "$remaining_path_segments" ]; do
      current_path_segment="${remaining_path_segments%%:*}"
      remaining_path_segments="${remaining_path_segments#*:}"

      if [ -n "$current_path_segment" ]; then # Process only non-empty segments
        if [ "$current_path_segment" != "$single_entry_to_remove" ]; then
          if [ -z "$temp_path_after_single_removal" ]; then
            temp_path_after_single_removal="$current_path_segment"
          else
            temp_path_after_single_removal="$temp_path_after_single_removal:$current_path_segment"
          fi
        fi
      elif [ -z "$temp_path_after_single_removal" ] && [ -z "$remaining_path_segments" ]; then
         # Path was/became empty, keeping result empty.
         : # No-op, temp_path_after_single_removal remains empty
      fi
    done
    new_path_intermediate="$temp_path_after_single_removal"
  done

  echo "$new_path_intermediate" # This is the ONLY echo to stdout, sending the new PATH back
}

_prepend_path() {
  target_path="$1"

  if [ -z "$target_path" ]; then
    return 1
  fi

  if [ -n "${IN_NIX_SHELL-}" ]; then
    PATH=$(_remove_path_entry "$target_path" "$PATH")
    export PATH
  else
    # split target path into individual components
    for entry in $(echo "$target_path" | tr ':' ' '); do
      # remove leading/trailing whitespace from each entry
      entry=$(echo "$entry" | xargs)
      if [ ! -d "$entry" ]; then
        printf "${_YELLOW}warning: non-existing directory %s${_RESET}\n" "$entry"
      elif [ -n "$entry" ] && [[ ":$PATH:" != *":${entry}:"* ]]; then
        if [ -z "$PATH" ]; then
          printf "${_RED}warning: empty PATH, adding first entry %s${_RESET}" "$entry"
          export PATH="$entry"
        else
          export PATH="${entry}:$PATH"
        fi
      fi
    done
  fi
}

_append_path() {
  target_path="$1"

  if [ -z "$target_path" ]; then
    return 1
  fi

  if [ -n "${IN_NIX_SHELL-}" ]; then
    PATH=$(_remove_path_entry "$target_path" "$PATH")
    export PATH
  else
    # split target path into individual components
    for entry in $(echo "$target_path" | tr ':' ' '); do
      # remove leading/trailing whitespace from each entry
      entry=$(echo "$entry" | xargs)
      if [ ! -d "$entry" ]; then
        printf "${_YELLOW}warning: non-existing directory %s${_RESET}\n" "$entry"
      elif [ -n "$entry" ] && [[ ":$PATH:" != *":${entry}:"* ]]; then
        if [ -z "$PATH" ]; then
          printf "${_RED}warning: empty PATH, adding first entry %s${_RESET}" "$entry"
          export PATH="$entry"
        else
          export PATH="${PATH}:${entry}"
        fi
      fi
    done
  fi
}

# bin folders
if [ -d "$HOME"/bin ]; then
  _append_path "$HOME/bin"
  for DIR in "$(find "$HOME/bin" -mindepth 1 -maxdepth 1 -print)"; do
    test -d "$DIR" && _append_path "$DIR"
  done > /dev/null 2>&1
fi

if [ -d "$HOME/.local/bin" ]; then
  _append_path "$HOME/.local/bin"
fi

# opt folder
if [ -d "$HOME"/opt ]; then
  for DIR in "$(find "$HOME/opt/" -mindepth 1 -maxdepth 1 -print)"; do
    test -d "$DIR/bin" && _prepend_path "$DIR/bin"
  done > /dev/null 2>&1
fi

### NODE

# node, npm binaries and settings
test -d "$HOME/.npm/bin" && _append_path "$HOME/.npm/bin"
export NPM_CONFIG_PREFIX="$HOME/.npm"
export NODE_REPL_HISTORY=

# nvm
test -d "$HOME/.nvm" && {
  # nvm is not compatible with the "NPM_CONFIG_PREFIX" environment variable
  unset NPM_CONFIG_PREFIX
}

# fnm (nvm alternative)
test -d "$HOME/.fnm" && {
  _prepend_path "$HOME/.fnm"
  [[ -z "${ZSH_VERSION}" ]] && eval "$(fnm env --shell bash)" || eval "$(fnm env --shell zsh)"
  test -f "$HOME/.redpill/completions/_fnm" \
  || fnm completions --shell zsh > "$HOME/.redpill/completions/_fnm"
}

# deno
test -d "$HOME/.deno/bin" && _prepend_path "$HOME/.deno/bin"

### RUBY

# ruby gems
if command -v ruby >/dev/null 2>&1 && command -v gem >/dev/null 2>&1; then
  DIR="$(gem environment gempath 2>/dev/null | cut -d: -f1)"
  test -d "$DIR/bin" && _prepend_path "$DIR/bin"
fi

unset DIR

# rvm
[[ -d "$HOME/.rvm" ]] && _prepend_path "$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

### OTHERS

# android
test -d /opt/android && _prepend_path "/opt/android/platform-tools:/opt/android/tools"

# composer binaries
test -d "$HOME"/.composer/vendor/bin && _prepend_path "$HOME/.composer/vendor/bin"

# go binaries and workspace
test -d /usr/local/go && _prepend_path "/usr/local/go/bin"
test -d "$HOME/code/go" && {
  export GOPATH="$HOME/code/go"
  _prepend_path "$HOME/code/go/bin"
}

# TODO this shouldn't be here
# Added by Toolbox App
test -d "$HOME"/.local/share/JetBrains/Toolbox/scripts && _prepend_path "$HOME/.local/share/JetBrains/Toolbox/scripts"

# rust cargo
test -f "$HOME/.cargo/env" && . "$HOME/.cargo/env"

# sdkman
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && {
  export SDKMAN_DIR="$HOME/.sdkman"
  source "${SDKMAN_DIR}/bin/sdkman-init.sh"
}

# remove duplicate entries from PATH
[ -n "$ZSH_VERSION" ] && {
  # case sensitive completions in omz
  # https://github.com/ohmyzsh/ohmyzsh/blob/69a6359f7cf8978d464573fb7b023ee3cd00181a/lib/completion.zsh#L17-L19
  export CASE_SENSITIVE="true"

  fpath+=("$HOME/.redpill/completions")

  # completions for tools installed via brew
  type brew &>/dev/null && {
    fpath+=("$(brew --prefix)/share/zsh/site-functions")
  }

  typeset -U PATH
  typeset -U path
  typeset -U fpath
}

# export PATH for other sessions
export PATH

# use nano if it exists; otherwise use vim
# command -v nano > /dev/null 2>&1 && export EDITOR=nano || export EDITOR=vim

# use vim as default editor
export EDITOR=vim

# set less options by default:
# -F: quit if output is less than one screen
# -R: keep color control chars
export LESS=-FR
export LESSHISTFILE=-
# --redraw-on-quit: print last screen when exiting less (v594 and newer)
[ $(less -V | awk '{print $2;exit}' | sed 's/[^0-9]//g') -ge 594 ] && {
  export LESS="-FR --redraw-on-quit"
  READNULLCMD=$(command -v less)
  export PAGER="$READNULLCMD"
}

[ "$USER" = root ] && ZSH_DISABLE_COMPFIX=true

skip_global_compinit=1

find "$(dirname -- "$0")" -name '.zshenv.*' -print0 | while read -d $'\0' file; do
  source "$file"
done
unset file
