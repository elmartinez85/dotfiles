# Dotfiles directory - auto-detect from symlink location
if [ -L "$HOME/.zshrc" ]; then
    export DOTFILES="$(dirname "$(dirname "$(readlink "$HOME/.zshrc")")")"
else
    # Fallback to default location if not symlinked
    export DOTFILES="$HOME/dotfiles"
fi

# Shell history configuration
HISTSIZE=50000                    # Number of commands to keep in memory
SAVEHIST=50000                    # Number of commands to save to file
HISTFILE=~/.zsh_history           # History file location
setopt HIST_IGNORE_ALL_DUPS       # Remove older duplicates from history
setopt HIST_FIND_NO_DUPS          # Don't show duplicates when searching
setopt HIST_SAVE_NO_DUPS          # Don't save duplicates to file
setopt INC_APPEND_HISTORY         # Append to history immediately
setopt SHARE_HISTORY              # Share history across all sessions
setopt EXTENDED_HISTORY           # Save timestamp and duration

# Homebrew PATH (Apple Silicon)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Disable Oh My Zsh theme (using Starship instead)
ZSH_THEME=""

# Oh My Zsh plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
  git
  brew
  macos
  node
  npm
  nvm
  python
  pip
  pyenv
  vscode
  z
)

source $ZSH/oh-my-zsh.sh

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# pyenv configuration
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# 1Password SSH agent
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# fzf configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zsh-autosuggestions (Homebrew installation)
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting (Homebrew installation) - must be at the end
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# User configuration
# Load custom aliases
if [ -f "$DOTFILES/config/.zsh_aliases" ]; then
    source "$DOTFILES/config/.zsh_aliases"
fi

# Load custom functions
if [ -f "$DOTFILES/config/.zsh_functions" ]; then
    source "$DOTFILES/config/.zsh_functions"
fi

# Initialize Starship prompt
# Configuration file: ~/.config/starship.toml (symlinked from $DOTFILES/config/starship.toml)
eval "$(starship init zsh)"