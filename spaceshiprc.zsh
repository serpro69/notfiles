# Git Options - https://spaceship-prompt.sh/sections/git/
# Render git synchronously (https://spaceship-prompt.sh/config/prompt/#Asynchronous-rendering)
SPACESHIP_GIT_ASYNC=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_TERRAFORM_ASYNC=true
SPACESHIP_TERRAFORM_SYMBOL="󱁢 "
SPACESHIP_PULUMI_ASYNC=true

SPACESHIP_GCLOUD_SYMBOL="󰅟 "

# async section (sections that are loading)
# ref: https://spaceship-prompt.sh/sections/async/
# add a space after async symbol … for the custom sections that are added at the end
SPACESHIP_ASYNC_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"
# anaconda
SPACESHIP_VENV_SYMBOL="󱔎 "
# kubernetes
SPACESHIP_KUBECTL_SHOW=true
SPACESHIP_KUBECTL_SYMBOL="󰠳 "
SPACESHIP_KUBECTL_COLOR="0066cd"
SPACESHIP_KUBECTL_VERSION_COLOR="0066cd"
# https://spaceship-prompt.sh/sections/kubectl/#Kubernetes-context-kubectl_context
SPACESHIP_KUBECTL_CONTEXT_COLOR_GROUPS=(
  # red if namespace is "kube-system"
  red    '\(kube-system)$'
  # else, red if "prod" is anywhere in the context or namespace
  red    'prod'
  # else, red if context name ends with ".k8s.local" _and_ namespace is "system"
  red    '\.k8s\.local \(system)$'
  # else, yellow if the entire content is "test-" followed by digits, and no namespace is displayed
  yellow '^test-[0-9]+$'
  # else, green if "test" is anywhere in the context or namespace
  green  'test'
)

# custom sections
# terraform/tofu backend
SPACESHIP_TFB_ASYNC=true
SPACESHIP_TFB_PREFIX=""
SPACESHIP_TFB_SUFFIX=" "
SPACESHIP_TFB_SYMBOL="󱐕 "
SPACESHIP_TFB_SYMBOL_PROD="󱓞 "
SPACESHIP_TFB_SYMBOL_TEST="󰙨 "
# pulumi backend
SPACESHIP_PLB_ASYNC=true
SPACESHIP_PLB_PREFIX=""
SPACESHIP_PLB_SUFFIX=" "
SPACESHIP_PLB_SYMBOL_PROD="󱓞 "
SPACESHIP_PLB_SYMBOL_TEST="󰙨 "
# opentofu
SPACESHIP_OPENTOFU_SUFFIX=" "
SPACESHIP_OPENTOFU_SYMBOL="󱊹 "

# custom spaceship sections are installed in $ZSH_CUSTOM/plugins
# see https://spaceship-prompt.sh/advanced/creating-section/ for more details
# also https://spaceship-prompt.sh/config/intro/#Configure-your-prompt on adding new sections
# TIP: use --before and --after flags to configure ordering of custom sections w/o modifying the default order list of built-in sections
#spaceship add --after opentofu tfb
#spaceship add --after terraform tfb
spaceship add opentofu
spaceship add --after opentofu tfb
spaceship add --after pulumi plb
