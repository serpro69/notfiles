[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://stand-with-ukraine.pp.ua)

# rebel-config

These are not the .files you're looking for

> These are my dotfiles. There are many like them, but these ones are mine.
> 
> My dotfiles are my tools. I must master and configure my dotfiles as I must master my own life.
> My dotfiles, without me, are useless. Without my dotfiles, I am useless. I must make my dotfiles work as I make my life work.
> 
> I will master the secrets of my dotfiles. I will keep my dotfiles clean and organized as I keep my thoughts organized. We will become one with each other.
> 
> Before the eyes of the command line gods, this creed I swear: my dotfile and I are the warriors of workflows, the masters of systems, the defenders of productivity. So be it, until victory is mine and there is no need for more configuration. 
> 
> This is the way (...to describe your dotfiles)

## Prerequisites 

- `git`
- `zsh`
  - install `zsh` (e.g. `sudo apt-get install zsh`)
  - set `zsh` as default shell: `chsh -s $(which zsh)`
    - restart user session to apply the change
    - _NB! `chsh` does not work on every system_

## Installation

1. Download or clone the repository

```shell
git clone --recurse-submodules git@github.com:serpro69/dotfiles.git ~/dotfiles
```

2. Run the init script

```shell
cd ~/dotfiles
./init.zsh
```

3. Restart the shell (or run `exec zsh`)
