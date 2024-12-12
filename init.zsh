#!/usr/bin/env -S zsh -df
#
# Sets up dotfiles in $HOME directory

zmodload zsh/stat

# Base dir as path relative to $HOME directory
DIR="${0:a:h}"

function msg() {
  case "$1" in
    ERROR) print -Pn '%F{red}' ;;
    SKIP) print -Pn '%F{yellow}' ;;
    OK) print -Pn '%F{green}' ;;
  esac

  [[ -n "$2" ]] && print -n "[$1: $2]" || print -n "[$1]"
  print -P %f
}

function symlink() {
  local error symlink lnflags
  local src dest

  # ln flags change on different platforms
  [[ "$OSTYPE" = darwin* ]] && lnflags="-nsfh" || lnflags="-nsfT"

  src="$1"
  dest="$2"

  if [[ -h "$dest" ]]; then
    symlink="$(zstat +link "$dest")"
    if [[ "$symlink" == "$src" ]]; then
      msg SKIP "file already symlinked"
      continue
    else
      echo -n "(old@ -> $symlink)"
    fi
  fi

  mkdir -p "${dest:h}"
  if error="$(ln $lnflags "$src" "$dest" 2>&1)"; then
    msg OK
  elif [[ -f "$dest" ]]; then
    msg ERROR "destination already exists (file)"
  elif [[ -d "$dest" ]]; then
    msg ERROR "destination already exists (dir)"
  else
    msg ERROR "$error"
  fi
}

local ZDOT=".redpill"

# Files to be symlinked to home directory
local -A dotfiles
dotfiles=(
# directories
  bluepill            "${ZDOT}/bluepill"
  git                 ".config/git"
  ohmyzsh             "${ZDOT}/ohmyzsh"
  tmux                ".tmux"
  tmux/.tmux.conf     ".tmux.conf"
  aliases             "${ZDOT}/aliases"
  arcrc               ".arcrc"
  dash_to_panel       ".dash_to_panel"
  dircolors           "${ZDOT}/dircolors"
  dotfiles_config     ".dotfiles_config"
  exports             "${ZDOT}/exports" # TODO merge with zshenv? NB! Currently sourced via zshrc
  functions           "${ZDOT}/functions"
  plugins             "${ZDOT}/plugins"
  # tools
  mise.zsh            ".mise.zsh"
  ghtoken             ".ghtoken"
  git-clone-init      ".git-clone-init"
  guake               ".guake"
  ideavimrc           ".ideavimrc"
  shellrc             "${ZDOT}/.shellrc"
  spaceshiprc.zsh     ".spaceshiprc.zsh"
  tmux.conf.local     ".tmux.conf.local"
  vimrc               ".vimrc"
  vimrc.bundles       ".vimrc.bundles"
  vrapperrc           ".vrapperrc"
  zprofile            "${ZDOT}/.zprofile"
  zshenv              "${ZDOT}/.zshenv"
  zshrc               "${ZDOT}/.zshrc"
)

local file src dest
# shellcheck disable=SC1073
# shellcheck disable=SC1058
# shellcheck disable=SC1072
for file (${(ko)dotfiles}); do
  src="$DIR/$file"
  dest="$HOME/${dotfiles[$file]}"

  echo -n "Linking $file... "
  symlink "$src" "$dest"
done

# additional stuff via 'extra'
local extra_dest="${HOME}/${ZDOT}/extra"
read "link_extra?Do you want to link the 'extra' utils file? (yes/no): "
if [[ -e "$extra_dest" || -L "$extra_dest" ]]; then
  echo -n "Linking extra to $extra_dest... "
  msg SKIP "file or link already exists"
elif [[ "$link_extra" == "yes" || "$link_extra" == "y" ]]; then
  echo -n "Linking extra to $extra_dest... "
  ln -s "$DIR/extra" "$extra_dest"
  msg OK
else
  echo -n "Note: you can add '$extra_dest' to include extra shell functionality in your environment "
fi

# Files specific to the platform
local system
case "$OSTYPE" in
  darwin*) system=darwin ;;
  linux-android) [[ "$PREFIX" = *com.termux* ]] && system=termux ;;
  linux*) system=linux ;;
esac

local -A platform
platform=(
  nano/darwin/nanorc  ".nanorc"
  nano/termux/nanorc  ".nanorc"
  nano/others/nanorc  ".config/nano/nanorc"
)

local -aU areas files
areas=(${(ko)platform%%/*})

local area
for area (${(o)areas}); do
  # Select the files based on the system
  files=(${(k)platform[(I)$area/$system/*]})
  # If no match for $system, select others
  (( $#files )) || files=(${(k)platform[(I)$area/others/*]})
  # If others not found, go to next area
  (( $#files )) || continue

  echo "Setting up $area:"

  for file (${(o)files}); do
    src="$DIR/$file"
    dest="$HOME/${platform[$file]}"

    echo -n "Linking $file... "
    symlink "$src" "$dest"
  done
done

# Add ZDOTDIR change to ~/.zshenv
grep -q "ZDOTDIR=\"\$HOME/${ZDOT}\"" "$HOME/.zshenv" 2>/dev/null || {
  echo -n "setting up ZDOTDIR in ~/.zshenv... "
  # .zshenv might be a symlink, so remove it first
  rm -f ~/.zshenv
  cat > ~/.zshenv <<EOF
ZDOTDIR="\$HOME/${ZDOT}"
. "\$ZDOTDIR/.zshenv"
EOF
  msg OK
}

# Add sourcing of .zshenv to .profile
grep -q "\. \"\$HOME/${dotfiles[zshenv]}\"" ~/.profile 2>/dev/null || {
  [[ -s ~/.profile ]] && echo >> ~/.profile || touch ~/.profile
  cat >> ~/.profile <<EOF
# load posix-compatible .zshenv
if [ -r "\$HOME/${dotfiles[zshenv]}" ]; then
    . "\$HOME/${dotfiles[zshenv]}"
fi
EOF
}

mkdir -p "$HOME/.redpill/completions"
