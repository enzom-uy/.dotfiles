export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias vim="nvim"
alias so="source ~/.zshrc"
alias syu="sudo pacman -Syu --noconfirm && yay -Syu --noconfirm"
alias lg="lazygit"
alias d="cd ~/dev/"
alias cl="xprop WM_CLASS"

## Config files and scripts
alias kittyconf="nvim ~/.config/kitty/kitty.conf"
alias zshrc="nvim ~/.zshrc"
alias tmuxrc="nvim ~/.tmux.conf"
alias edscript="nvim ~/.config/scripts/"

## Move all config files into .config folder
alias upd="cp ~/.zshrc ~/.config && cp ~/.tmux.conf ~/.config && cp ~/.xinitrc ~/.config/ && cp -r ~/.dwm ~/.config"

## Custom scripts
alias p=". ~/.config/scripts/pj.sh"
alias c=". ~/.config/scripts/cfgs.sh"
alias bg=". ~/.config/scripts/randombg.sh"
alias mdrives=". ~/.config/scripts/mountdrives.sh"

export PATH=$PATH:/home/enzom/.spicetify
