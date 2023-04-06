# Setup fzf
# ---------
if [[ ! "$PATH" == */home/sergio/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/sergio/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/sergio/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/sergio/.fzf/shell/key-bindings.bash"
