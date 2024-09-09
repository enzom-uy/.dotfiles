# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(git)


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/enzom/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


source $ZSH/oh-my-zsh.sh


alias l="exa -l --icons --group-directories-first -a --sort=type"
alias d="z ~/dev/"
alias pnpmx="pnpm dlx"

alias kittyconf="nvim ~/.config/kitty/kitty.conf"
alias tmuxrc="nvim ~/.tmux.conf"
alias upd="cp ~/.zshrc ~/.config && cp ~/.tmux.conf ~/.config"


alias lg="lazygit"
alias zshrc="nvim ~/.zshrc"
alias sshwsl="kitty +kitten ssh enzom@100.72.23.60"
alias so="source ~/.zshrc"
alias vim="nvim"

alias cd="z"


eval "$(zoxide init zsh)"


## Custom scripts
alias p="source ~/.config/scripts/pj.sh"
alias c="source ~/.config/scripts/cfgs.sh"
alias fwall="source ~/.config/scripts/fzf-wall.sh"
alias bg="source ~/.config/scripts/randombg.sh"
alias sbg="source ~/.config/scripts/saferandombg.sh"
