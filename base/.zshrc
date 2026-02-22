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
export ZSH="$HOME/.oh-my-zsh"/

# Disable Oh My Zsh theme (using Starship instead)
ZSH_THEME=""

# Oh My Zsh plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
  git
  brew
  macos
  python
  pip
  pyenv
  vscode
  z
)

source $ZSH/oh-my-zsh.sh

# nvm
export NVM_DIR="$HOME/.nvm"

# pyenv configuration
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# 1Password SSH agent
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# API Keys (load from local file if it exists - not committed to git)
[ -f "$HOME/.env_secrets" ] && source "$HOME/.env_secrets"

# Use fd with fzf for better performance and respects .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# fzf configuration (load after setting env vars)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable cd ** fuzzy completion with fd (must be after fzf.zsh is sourced)
_fzf_compgen_path() {
  fd --hidden --follow --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude .git . "$1"
}

# fzf options with preview using bat
export FZF_DEFAULT_OPTS="
  --height 60%
  --layout=reverse
  --border
  --preview 'bat --color=always --style=numbers --line-range=:500 {}'
  --preview-window=right:50%:wrap
  --bind='ctrl-/:toggle-preview'
"

# Preview directories with eza when using ALT-C
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {}'"

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
if [ -f "$DOTFILES/base/.zsh_aliases" ]; then
    source "$DOTFILES/base/.zsh_aliases"
fi

# Load custom functions
if [ -f "$DOTFILES/base/.zsh_functions" ]; then
    source "$DOTFILES/base/.zsh_functions"
fi

# Initialize Starship prompt
# Configuration file: ~/.config/starship.toml (symlinked from $DOTFILES/base/starship.toml)
eval "$(starship init zsh)"
