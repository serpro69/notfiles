#
# OpenTofu Workspaces
#
# OpenTofu is a fork of Terraform that is open-source, community-driven, and managed by the Linux Foundation.
# Link: https://opentofu.org/
#
# This section shows you the current OpenTofu workspace
# Link: https://opentofu.org/docs/language/state/workspaces/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_OPENTOFU_SHOW="${SPACESHIP_OPENTOFU_SHOW=true}"
SPACESHIP_OPENTOFU_ASYNC="${SPACESHIP_OPENTOFU_ASYNC=true}"
SPACESHIP_OPENTOFU_PREFIX="${SPACESHIP_OPENTOFU_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_OPENTOFU_SUFFIX="${SPACESHIP_OPENTOFU_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_OPENTOFU_SYMBOL="${SPACESHIP_OPENTOFU_SYMBOL="🍢 "}"
SPACESHIP_OPENTOFU_COLOR="${SPACESHIP_OPENTOFU_COLOR="226"}"

# ------------------------------------------------------------------------------
# Section
# ----------------------------------------------- -------------------------------

spaceship_opentofu() {
  [[ $SPACESHIP_OPENTOFU_SHOW == false ]] && return

  spaceship::exists tofu || return

  # Show Tofu Workspaces when exists
  spaceship::upsearch .terraform/environment || return

  local tofu_workspace=$(<.terraform/environment)
  [[ -z $tofu_workspace ]] && return

  spaceship::section::v4 \
    --color "$SPACESHIP_OPENTOFU_COLOR" \
    --prefix "$SPACESHIP_OPENTOFU_PREFIX" \
    --suffix "$SPACESHIP_OPENTOFU_SUFFIX" \
    --symbol "$SPACESHIP_OPENTOFU_SYMBOL" \
    "$tofu_workspace"
}

