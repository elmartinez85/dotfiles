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

# Set name of the theme to load
# Using Spaceship theme - install with: git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
# Then symlink: ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
ZSH_THEME="spaceship"

# Spaceship prompt configuration
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  node          # Node.js section
  python        # Python section
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

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

