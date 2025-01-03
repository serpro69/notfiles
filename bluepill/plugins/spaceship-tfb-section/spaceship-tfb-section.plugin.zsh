# Terraform backend
# Currently supports GCS remote backends

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_TFB_SHOW="${SPACESHIP_TFB_SHOW=true}"
SPACESHIP_TFB_ASYNC="${SPACESHIP_TFB_ASYNC=true}"
SPACESHIP_TFB_PREFIX="${SPACESHIP_TFB_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_TFB_SUFFIX="${SPACESHIP_TFB_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_TFB_SYMBOL="${SPACESHIP_TFB_SYMBOL="󱁢 "}"
SPACESHIP_TFB_SYMBOL_PROD="${SPACESHIP_TFB_SYMBOL}"
SPACESHIP_TFB_SYMBOL_TEST="${SPACESHIP_TFB_SYMBOL}"
# colors are described at https://spaceship-prompt.sh/config/prompt/
SPACESHIP_TFB_COLOR="${SPACESHIP_TFB_COLOR="105"}"
SPACESHIP_TFB_COLOR_PROD="red"
SPACESHIP_TFB_COLOR_TEST="green"
# cut out this string from output, e.g. 'terraform/state/test' -> 'test'
SPACESHIP_TFB_PARENT="terraform/state/"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_tfb() {
  [[ $SPACESHIP_TFB_SHOW == false ]] && return

  # Check if terraform is installed
  spaceship::exists terraform || return

  # Show Terraform Backend when exists
  spaceship::upsearch .terraform/terraform.tfstate || return

  local terraform_backend=$(cat .terraform/terraform.tfstate | jq -r '.backend.config.prefix')
  local tfb="${terraform_backend#${SPACESHIP_TFB_PARENT}}"
  [[ -z $terraform_backend ]] && return
  [[ $terraform_backend == "null" ]] && return

  if [[ ${terraform_backend} =~ .*prod.* ]]; then
    SPACESHIP_TFB_COLOR="${SPACESHIP_TFB_COLOR_PROD}"
    SPACESHIP_TFB_SYMBOL="${SPACESHIP_TFB_SYMBOL_PROD}"
  elif [[ ${terraform_backend} =~ .*test.* ]]; then
    SPACESHIP_TFB_COLOR="${SPACESHIP_TFB_COLOR_TEST}"
    SPACESHIP_TFB_SYMBOL="${SPACESHIP_TFB_SYMBOL_TEST}"
  fi

  # Display ansible section
  spaceship::section::v4 \
    --color "$SPACESHIP_TFB_COLOR" \
    --prefix "$SPACESHIP_TFB_PREFIX" \
    --suffix "$SPACESHIP_TFB_SUFFIX" \
    --symbol "$SPACESHIP_TFB_SYMBOL" \
    "$tfb"
}
