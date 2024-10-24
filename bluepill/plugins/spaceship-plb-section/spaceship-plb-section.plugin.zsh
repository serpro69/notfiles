# PuLumi Backend
# Currently supports GCS remote backends

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_PLB_SHOW="${SPACESHIP_PLB_SHOW=true}"
SPACESHIP_PLB_ASYNC="${SPACESHIP_PLB_ASYNC=true}"
SPACESHIP_PLB_PREFIX="${SPACESHIP_PLB_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_PLB_SUFFIX="${SPACESHIP_PLB_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_PLB_SYMBOL="${SPACESHIP_PLB_SYMBOL="󱗿 "}"
SPACESHIP_PLB_SYMBOL_PROD="${SPACESHIP_PLB_SYMBOL}"
SPACESHIP_PLB_SYMBOL_TEST="${SPACESHIP_PLB_SYMBOL}"
# colors are described at https://spaceship-prompt.sh/config/prompt/
SPACESHIP_PLB_COLOR="${SPACESHIP_PLB_COLOR="208"}"
SPACESHIP_PLB_COLOR_PROD="red"
SPACESHIP_PLB_COLOR_TEST="green"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_plb() {
  [[ $SPACESHIP_PLB_SHOW == false ]] && return

  # Check if pulumi is installed
  spaceship::exists pulumi || return

  # Show pulumi backend when inside a pulumi project
  spaceship::upsearch Pulumi.yaml || return
  # Show only when logged in to a backend
  if [ ! -f ${HOME}/.pulumi/credentials.json]; then return; fi

  local pulumi_backend=$(cat $HOME/.pulumi/credentials.json | jq '.current' | tr -d '"')
  local plb="${pulumi_backend##*/}"
  [[ -z $pulumi_backend ]] && return
  [[ $pulumi_backend == "null" ]] && return

  if [[ ${pulumi_backend} == "file://~" ]]; then
    SPACESHIP_PLB_COLOR="${SPACESHIP_PLB_COLOR}"
    plb="local"
  elif [[ ${pulumi_backend} =~ .*prod.* ]]; then
    SPACESHIP_PLB_COLOR="${SPACESHIP_PLB_COLOR_PROD}"
    SPACESHIP_PLB_SYMBOL="${SPACESHIP_PLB_SYMBOL_PROD}"
  elif [[ ${pulumi_backend} =~ .*test.* ]]; then
    SPACESHIP_PLB_COLOR="${SPACESHIP_PLB_COLOR_TEST}"
    SPACESHIP_PLB_SYMBOL="${SPACESHIP_PLB_SYMBOL_TEST}"
  fi

  # Display ansible section
  spaceship::section::v4 \
    --color "$SPACESHIP_PLB_COLOR" \
    --prefix "$SPACESHIP_PLB_PREFIX" \
    --suffix "$SPACESHIP_PLB_SUFFIX" \
    --symbol "$SPACESHIP_PLB_SYMBOL" \
    "$plb"
}
