# ~/.zprofile: executed by zsh

# you will find all other settings in "~/.redpill/"

############# INCLUDE ####################################

# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{config_dotfiles,path,load,exports,colors,icons,aliases,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

############# EXTRA ####################################

if [ -d $HOME/.redpill ]; then

  # define the path from "red-pill"
  export ZSH=$HOME/.redpill

  if [[ -z "$CONFIG_ZSH_THEME" ]]; then
    CONFIG_ZSH_THEME="random"
  fi

  # Set name of the theme to load.
  # Look in ~/.redpill/themes/
  # Optionally, if you set this to "random", it'll load a random theme each
  # time that you enter the matrix.
  ZSH_THEME="$CONFIG_ZSH_THEME"

  # Which plugins would you like to load? (plugins can be found in ~/.redpill/plugins/*)
  # Custom plugins may be added to ~/.redpill/custom/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.
  plugins=($(echo $CONFIG_ZSH_PLUGINS | sed 's/(//g' | sed 's/)//g'))

  source $HOME/.redpill/redpill-init-zsh.sh
fi


# Added by Toolbox App
export PATH="$PATH:/home/sergio/.local/share/JetBrains/Toolbox/scripts"