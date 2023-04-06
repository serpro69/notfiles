# TAKE A LOOK AT THIS SOURCES
#
# - http://www.commandlinefu.com/commands/browse/sort-by-votes
# - https://twitter.com/climagic

# This might seem backwards when you look at the "Bash startup files" reference
# <http://www.gnu.org/software/bash/manual/bashref.html#Bash-Startup-Files> or
# the "INVOCATION" section in the man page. However, my workflow typically is:
#
# * Open a terminal with four shells in tabs
# * Edit code in Vim, and shell out using ":sh"
#
# The initial four shells are login shells, so they source ~/.bash_profile.
# The shells spawned by Vim are not login shells, but they /are/ interactive.
# They look for .bashrc, but not .bash_profile. Because they are interactive,
# PS1 is set, so I know it is OK to run all the shell initialisation code.
#
# If I were to put the contents of ~/.bash_profile in ~/.bashrc and make the
# former source the latter, I would have to wrap the entire contents of the
# latter in a huge "if [ -n "$PS1" ]; then ... fi" block. That does not really
# help readability, does it?
#
# (Of course, I could also do "[ -z "$PS1" ] && return;" in ~/.bashrc and still
# source it from ~/.bash_profile, but way back when I started my .bash_profile
# customisations, I did not know about login vs. non-login shells, nor did I
# know you could do "return" in a sourced file. If I were to change things now,
# I would lose my blame history, which seems too high a price to pay.)
#
# The difference between a login shell and an interactive non-login shell is
# moot for me, so I consider all interactive shells to be equal and wanting
# the same treatment.
#
# If you're wondering what a non-interactive shell might be, i.e. when PS1
# might not be set, try this:
#
#     ssh localhost 'echo "PS1: >$PS1<"'
#

# README: If you write Bash, read this before you write another line of code ->
#           http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/

# If not running interactively: exit immediately.
# Note that 'return' works because the file is sourced, not executed.

if [[ $- != *i* ]] || [ -z "$PS1" ]; then
  return 0
fi

# try to load global-bashrc
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

source ~/.bash_profile

complete -C /usr/local/bin/terraform terraform

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/sergio/.sdkman"
[[ -s "/home/sergio/.sdkman/bin/sdkman-init.sh" ]] && source "/home/sergio/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

complete -C /home/sergio/.local/lib/vault/vault vault
