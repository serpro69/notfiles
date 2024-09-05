# Git Options - https://spaceship-prompt.sh/sections/git/
# Render git synchronously (https://spaceship-prompt.sh/config/prompt/#Asynchronous-rendering)
SPACESHIP_GIT_ASYNC=false
SPACESHIP_TERRAFORM_ASYNC=true
SPACESHIP_TERRAFORM_SYMBOL="󱁢 "
SPACESHIP_PULUMI_ASYNC=true
# custom section
SPACESHIP_TFB_ASYNC=true
SPACESHIP_TFB_PREFIX=""
SPACESHIP_TFB_SUFFIX=" "
SPACESHIP_TFB_SYMBOL="󱐕 "
SPACESHIP_TFB_SYMBOL_PROD="󱓞 "
SPACESHIP_TFB_SYMBOL_TEST="󰙨 "

# custom spaceship sections are installed in $ZSH_CUSTOM/plugins
# see https://spaceship-prompt.sh/advanced/creating-section/ for more details
# also https://spaceship-prompt.sh/config/intro/#Configure-your-prompt on adding new sections
# TIP: use --before and --after flags to configure ordering of custom sections w/o modifying the default order list of built-in sections
spaceship add --after terraform tfb
