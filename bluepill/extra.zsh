#!/usr/bin/env bash

export DOTFILESSRCDIR="/home/sergio/dotfiles/"

GIT_AUTHOR_NAME="Serhii Prodan"
# shellcheck disable=SC2034
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
#git config --file="$HOME/.gitconfig.extra" user.name "$GIT_AUTHOR_NAME"

GIT_AUTHOR_EMAIL="serpro@disroot.org"
# shellcheck disable=SC2034
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
#git config --file="$HOME/.gitconfig.extra" user.email "$GIT_AUTHOR_EMAIL"

#git config --file="$HOME/.gitconfig.extra" push.default simple

# shellcheck disable=SC2034
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#767676,underline"

#alias idea="intellij-idea-community"
# Some safe-guard aliases
#alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# shellcheck disable=SC2142
alias dskoff='_f(){ udisksctl power-off -b "$1"; unset -f _f }; _f'

#alias vagrant='
# mkdir -p ~/.vagrant.d/{boxes,data,tmp}; \
# docker run -it --rm \
#   -e LIBVIRT_DEFAULT_URI \
#   -v /var/run/libvirt/:/var/run/libvirt/ \
#   -v ~/.vagrant.d:/.vagrant.d \
#   -v $(pwd):$(pwd) \
#   -w $(pwd) \
#   --network host \
#   serpro69:vagrant-libvirt \
#   vagrant'

if [[ "$(echo $SHELL | awk -F/ '{print $NF}')" == "zsh" ]]; then
  #fix using ^ in git commands, i.e. HEAD^
  setopt NO_NOMatch

  # Share zsh history
  setopt SHARE_HISTORY
fi

trim() {
  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"
  printf '%s' "$var"
}

# Alias for sudo to preserve path
alias sudo='sudo env PATH="$PATH"'

typeset -aU path

# exa aliases
alias ela='exa -laFh'
alias el='exa -lFh --group-directories-first'

# Elhub aliases
alias deploy-runner-old='wget -q -o /dev/null -O - https://code.elhub.cloud/projects/DEV/repos/devxp-linux-scripts/raw/scripts/deploy-runner.sh?at=refs%2Fheads%2Fmaster | bash -s --'

deploy_runner() {
  wget -q -o /dev/null -O ~/.local/bin/deploy-runner.main.kts https://code.elhub.cloud/projects/DEV/repos/devxp-linux-scripts/raw/scripts/deploy-runner.main.kts?at=refs%2Fheads%2Fmaster
  kotlinc-jvm -script ~/.local/bin/deploy-runner.main.kts -- -a api_key --no-use-proxy $*
}

alias orchid-run='kscript https://code.elhub.cloud/projects/DEV/repos/devxp-linux-scripts/raw/scripts/orchid-run.kts?at=refs%2Fheads%2Fmaster'

vl() {
  unset VAULT_TOKEN
  vault login -method=ldap username=sergei.prodanov
  export VAULT_TOKEN=$(vault print token)
}

arcl() {
  local br=$(git rev-parse --abbrev-ref HEAD)
  git stash save "pre-arcland on $br"
  git co master
  git pull-and-rebase-master || exit 1
  arc patch $1 || exit 1
  arc land || exit 1
  git co "$br"
  echo "landed changes for $1 and checked out $br, you can unstash changes now if any"
}
# end

# misc
# shellcheck disable=SC2142
alias clipcat='_f(){ cat "$1" | xclip -selection clipboard; unset -f _f }; _f'
alias clippwd='_f(){ pwd | xclip -selection clipboard | trim; unset -f _f}; _f'
alias cdtemp='cd $(mktemp -d)'
# shellcheck disable=SC2142
alias cp.='_f(){ cp "$1" . }; _f'
# shellcheck disable=SC2142
alias kp='_f(){ kill -9 $(ps aux | grep "$1" | grep -v grep | awk '"'"'{print $2}'"'"'); unset -f _f }; _f'
# shellcheck disable=SC2142
alias bakf='_f() { cp $1{,.bak.$(date +%s%N)} ; unset -f _f }; _f'
alias listening='lsof -Pi | grep LISTEN'
alias lzd='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v /home/sergio/.lazydocker/config:/.config/jesseduffield/lazydocker lazyteam/lazydocker'
alias citrix='docker run --dns 8.8.8.8 --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password -e VNCOPTIONS="-publicIP 127.0.0.1" serpro69/kasm-citrix-workspace'
# python venv
# strangely there is a 'workon' function, but no opposite one
alias workoff='deactivate'

# nvim installed via appimage
alias nvim="$HOME/bin/nvim.appimage"

# similar to 'lzd' alias, but uses a docker context to run against a remote host
# used only against elhub contexts for now
# shellcheck disable=SC2112
function lzdc() {
  if [[ -z "$1" ]]; then
    echo "\e[01;31mError: missing docker context name. Run with --help for usage details\e[0m" >&2
    return 1
  elif [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Runs lazydocker on a docker context host"
    echo "Usage: lzdc <context-name>" >&2
    return 0
  fi
  docker --context $1 run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /home/sergeip/.lazydocker/config:/.config/jesseduffield/lazydocker \
    docker.jfrog.elhub.cloud/lazyteam/lazydocker
}

remind() {
  local summary=$1
  local body=$2
  echo "notify-send -u critical -t 10 '${summary}' '${body}'" | at "${@:3}"
}

# Python venv wrapper
if [ "$VIRTUALENVWRAPPER_PYTHON" = "" ]
then
    VIRTUALENVWRAPPER_PYTHON="$(command \which python3)"
fi

. /home/sergio/.local/bin/virtualenvwrapper.sh
source "$HOME/.autoenv/activate.sh"

# run gitwatch for todoer
if [ -f "/home/sergio/todoer/startup.sh" ]; then
  /home/sergio/todoer/startup.sh
fi

# FuzzyFinder
[ -f ~/.fzf.zsh ] && source "$HOME/.fzf.zsh"

fh() {
  # shellcheck disable=SC2046
  # shellcheck disable=SC2015
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}

export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
