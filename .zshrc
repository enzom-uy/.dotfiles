export WALLPIPER_PORTAL=hyprland
export WALLPIPER_PROTON_BIN="/home/enzom/.local/share/Steam/compatibilitytools.d/GE-Proton11-5-x86_64/proton"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Aliases

alias cd="z"
alias vim="nvim"
alias so="source ~/.zshrc"
alias lg="lazygit"
alias gcl="git clone"
alias l="eza -l --icons --group-directories-first -a --sort=type"
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

alias x="cd /opt/lampp/htdocs/"

## Move all config files into .config folder
alias upd="cp ~/.zshrc ~/.config && cp ~/.tmux.conf ~/.config && cp ~/.zshrc-scripts ~/.config"

## Custom scripts
alias p=". ~/.config/scripts/pj.sh"

source $HOME/.zshrc-scripts

eval "$(zoxide init zsh)"
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
