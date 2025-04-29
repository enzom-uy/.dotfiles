export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"
CATPPUCCIN_FLAVOR="mocha"
CATPPUCCIN_SHOW_TIME=true
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
# source $ZSH/oh-my-zsh.sh
# source $HOME/.zsh.env





export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$HOME/.local/bin:$PATH
export PATH=/mnt/c/npiperelay.exe:$PATH


# Aliases

alias cd="z"
# alias vim="nvim"
alias so="source ~/.zshrc"
alias syu="sudo pacman -Syu --noconfirm && yay -Syu --noconfirm"
alias lg="lazygit"
alias l="exa -l --icons --group-directories-first -a --sort=type"
alias d="z ~/dev/"
alias n="z /mnt/c/Users/enzom/obsidian && nvim"
alias pnpmx="pnpm dlx"
alias idea="/mnt/f/IntelliJ\ IDEA\ Community\ Edition\ 2024.3.5/bin/idea64.exe"

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

# Inicia el relay solo si no está corriendo
if ! pgrep -f "socat.*discord-ipc-0" >/dev/null; then
    PIPERELAY="/mnt/c/npiperelay.exe"  # Ajusta la ruta
    rm -f /tmp/discord-ipc-0
    socat UNIX-LISTEN:/tmp/discord-ipc-0,fork EXEC:"$PIPERELAY -ep -s //./pipe/discord-ipc-0" 2>/dev/null &
fi


nvim() {
  if ! pidof socat > /dev/null 2>&1; then
    [ -e /tmp/discord-ipc-0 ] && rm -f /tmp/discord-ipc-0
    socat UNIX-LISTEN:/tmp/discord-ipc-0,fork \ 
      EXEC:\"/mnt/c/npiperelay.exe //./pipe/discord-ipc-0\" 2>/dev/null &
  fi

  if [ $# -eq 0 ]; then
    command nvim
  else
    command nvim "$@"
  fi
}



source $ZSH/oh-my-zsh.sh

# eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


# pnpm
export PNPM_HOME="/home/enzom/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#

