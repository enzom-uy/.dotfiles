export ZDOTDIR=$HOME
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
CATPPUCCIN_FLAVOR="mocha"
CATPPUCCIN_SHOW_TIME=true
GTK_THEME="Breeze-Dark:dark"
plugins=(zsh-syntax-highlighting zsh-autosuggestions)

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

source $ZSH/oh-my-zsh.sh
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Android
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"

# Cargo (Rust)
export PATH="$HOME/.cargo/bin:$PATH"

# Local user bin
export PATH="$HOME/.local/bin:$PATH"

# Windows relay (WSL)
export PATH="/mnt/c/npiperelay.exe:$PATH"

# opencode
export PATH="/home/enzom/.opencode/bin:$PATH"

# NVM lazy load
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Aliases

alias cd="z"
alias vim="nvim"
alias em="emacsclient -t"
alias so="source ~/.zshrc"
alias syu="sudo pacman -Syu --noconfirm && yay -Syu --noconfirm"
alias lg="lazygit"
alias gcl="git clone"
alias l="exa -l --icons --group-directories-first -a --sort=type"
alias d="z ~/dev/"
alias n="z ~/notes/ && nvim"
alias pnpmx="pnpm dlx"
alias btop="btop --low-color"
alias oc="opencode"

## Config files and scripts
alias kittyconf="nvim ~/.config/kitty/kitty.conf"
alias zshrc="nvim ~/.zshrc"
alias tmuxrc="nvim ~/.tmux.conf"
alias edscript="nvim ~/.config/scripts/"
alias ide=". ~/.config/scripts/ide.sh"
alias neofetch="neofetch --source ~/Pictures/wallpapers/"
alias wal=". ~/.config/scripts/wal.sh"

alias x="cd /opt/lampp/htdocs/"

## Move all config files into .config folder
alias upd="cp ~/.zshrc ~/.config && cp ~/.tmux.conf ~/.config && cp ~/.zshrc-scripts ~/.config"

## Custom scripts
alias p=". ~/.config/scripts/pj.sh"
alias c=". ~/.config/scripts/cfgs.sh"
alias bg=". ~/.config/scripts/randombg.sh"

source $HOME/.zshrc-scripts

# pnpm
export PNPM_HOME="/home/enzom/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

declare -A pomo_options
pomo_options["work"]="0.02"
pomo_options["break"]="10"

pomodoro () {
  if [ -n "$1" -a -n "${pomo_options["$1"]}" ]; then
  val=$1
  echo $val | lolcat
  timer ${pomo_options["$val"]}m
  spd-say -i 5 -t female1 "'$val' session done"
  fi
}

alias wo="pomodoro 'work'"
alias br="pomodoro 'break'"

eval "$(zoxide init zsh)"
