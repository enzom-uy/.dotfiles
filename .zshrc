export ZSH="$HOME/.oh-my-zsh"

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi

ZSH_THEME="archcraft"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
source $HOME/.zsh.env

# Aliases

alias vim="nvim"
alias so="source ~/.zshrc"
alias syu="sudo pacman -Syu --noconfirm && yay -Syu --noconfirm"
alias lg="lazygit"
alias d="cd ~/dev/"
alias n="cd ~/notes && nvim"

## Config files and scripts
alias kittyconf="nvim ~/.config/kitty/kitty.conf"
alias zshrc="nvim ~/.zshrc"
alias tmuxrc="nvim ~/.tmux.conf"
alias edscript="nvim ~/.config/scripts/"
alias ide=". ~/.config/scripts/ide.sh"
alias neofetch="neofetch --source ~/Pictures/wallpapers/"

## Move all config files into .config folder
alias upd="cp ~/.zshrc ~/.config && cp ~/.tmux.conf ~/.config"

## Custom scripts
alias p=". ~/.config/scripts/pj.sh"
alias c=". ~/.config/scripts/cfgs.sh"
alias bg=". ~/.config/scripts/randombg.sh"


# pnpm
export PNPM_HOME="/home/enzom/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

