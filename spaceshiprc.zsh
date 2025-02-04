# Git Options - https://spaceship-prompt.sh/sections/git/
# Render git synchronously (https://spaceship-prompt.sh/config/prompt/#Asynchronous-rendering)
SPACESHIP_GIT_ASYNC=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_TERRAFORM_ASYNC=true
SPACESHIP_TERRAFORM_SYMBOL="󱁢 "
SPACESHIP_PULUMI_ASYNC=true

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

# custom spaceship sections are installed in $ZSH_CUSTOM/plugins
# see https://spaceship-prompt.sh/advanced/creating-section/ for more details
# also https://spaceship-prompt.sh/config/intro/#Configure-your-prompt on adding new sections
# TIP: use --before and --after flags to configure ordering of custom sections w/o modifying the default order list of built-in sections
#spaceship add --after opentofu tfb
#spaceship add --after terraform tfb
spaceship add opentofu
spaceship add --after opentofu tfb
spaceship add --after pulumi plb
