# Dotfiles for macOS Setup

A comprehensive collection of dotfiles and scripts to quickly set up a new MacBook Pro with essential tools, applications, and personalized system preferences.

## Quick Start

### First Time Setup

1. **Clone this repository** to your new Mac:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. **Make scripts executable**:
   ```bash
   chmod +x bootstrap.sh
   chmod +x scripts/*.sh
   ```

3. **Run the bootstrap script**:
   ```bash
   ./bootstrap.sh
   ```

4. **Restart your terminal** or source your new configuration:
   ```bash
   source ~/.zshrc
   ```

## What Gets Installed

### CLI Tools (via Homebrew)
- **chezmoi** - Dotfiles manager
- **curl** - Data transfer tool
- **ffmpeg** - Multimedia framework
- **fzf** - Fuzzy finder for command-line
- **gh** - GitHub CLI
- **git** - Version control system
- **jq** - JSON processor
- **node** - JavaScript runtime
- **nvm** - Node version manager
- **python@3.14** - Python programming language
- **pyenv** - Python version manager
- **ripgrep** - Fast recursive search tool
- **tree** - Directory tree visualization
- **zsh-autosuggestions** - Fish-like autosuggestions for zsh
- **zsh-syntax-highlighting** - Syntax highlighting for zsh commands

### Applications (via Homebrew Cask)
- **1Password** - Password manager
- **1Password CLI** - Command-line interface for 1Password
- **Cursor** - AI-powered code editor
- **Helium Browser** - Floating browser window
- **Obsidian** - Knowledge base and note-taking app
- **PearCleaner** - Mac cleaning utility
- **Rectangle Pro** - Window management tool
- **VSCodium** - VS Code without telemetry

### Shell Configuration
- **Oh My Zsh** - Framework for managing zsh configuration
- **Spaceship Prompt** - Minimal, powerful, and customizable prompt
- **Custom plugins** - git, brew, macos, node, npm, nvm, python, pip, pyenv, vscode, z

### macOS System Preferences

The bootstrap script automatically configures:

#### Finder
- Show hidden files
- Show all file extensions

#### Screenshots
- Save location: `~/Documents/Screenshots`
- Disable shadows in screenshots

#### Dock
- Auto-hide enabled
- Icon size: Medium (48px)
- Position: Right side of screen
- Faster animations

#### Trackpad
- Natural scrolling disabled

#### Keyboard
- Press-and-hold disabled (enables key repeat)
- Faster key repeat rate
- Shorter delay before key repeat

## Directory Structure

```
dotfiles/
├── bootstrap.sh                 # Main setup script with symlink strategy
├── Brewfile                     # Homebrew package definitions
├── README.md                    # This file
├── config/
│   ├── .gitconfig              # Git configuration (symlinked to ~/.gitconfig)
│   ├── .zshrc                  # Zsh configuration (symlinked to ~/.zshrc)
│   ├── .zsh_aliases            # Custom aliases
│   └── .zsh_functions          # Custom functions
└── scripts/
    ├── configure_macos.sh      # macOS system preferences
    ├── install_homebrew.sh     # Homebrew installation
    ├── install_ohmyzsh.sh      # Oh My Zsh installation
    ├── install_spaceship.sh    # Spaceship theme installation
    └── uninstall.sh            # Uninstall script for testing
```

## Symlink Strategy

This dotfiles setup uses **symbolic links** instead of copying files. This means:

- `~/.zshrc` → `~/dotfiles/config/.zshrc`
- `~/.gitconfig` → `~/dotfiles/config/.gitconfig`

**Benefits:**
- Edit configuration files from anywhere
- Changes are automatically tracked in your dotfiles repository
- No need to manually sync or re-run bootstrap
- Single source of truth for all configurations

## Customization

### Adding Custom Aliases

Edit `~/dotfiles/config/.zsh_aliases`:
```bash
alias ll="ls -lah"
alias ..="cd .."
alias gs="git status"
```

### Adding Custom Functions

Edit `~/dotfiles/config/.zsh_functions`:
```bash
mkcd() {
    mkdir -p "$1" && cd "$1"
}
```

### Modifying Git Configuration

Edit `~/dotfiles/config/.gitconfig` to change:
- User name and email
- Git aliases
- Default editor
- Merge/diff tools

### Customizing Spaceship Prompt

Edit the `SPACESHIP_PROMPT_ORDER` section in `~/dotfiles/config/.zshrc` to customize which prompt sections appear and their order.

## Updating

### Update Homebrew Packages
```bash
brew update
brew upgrade
```

### Update Oh My Zsh
```bash
omz update
```

### Update Spaceship Theme
```bash
cd $ZSH_CUSTOM/themes/spaceship-prompt
git pull
```

### Add New Homebrew Packages
1. Edit the `Brewfile`
2. Add packages using `brew "package-name"` or `cask "app-name"`
3. Run:
   ```bash
   brew bundle --file=~/dotfiles/Brewfile
   ```

## Useful Commands

### General
- `brew update && brew upgrade` - Update all Homebrew packages
- `omz update` - Update Oh My Zsh
- `cd ~/dotfiles && git status` - Check for uncommitted dotfile changes

### fzf Shortcuts
- `CTRL-R` - Search command history
- `CTRL-T` - Search files and directories
- `ALT-C` - Change directory using fuzzy search

### Oh My Zsh Plugins

The `z` plugin lets you jump to frequently used directories:
```bash
z documents  # Jump to ~/Documents (or any frequently visited path matching "documents")
```

## Git Configuration

The included `.gitconfig` has these useful aliases:
- `git co` → checkout
- `git br` → branch
- `git ci` → commit
- `git st` → status
- `git lg` → pretty log graph
- `git recent` → branches sorted by last modified
- `git undo` → undo last commit (keep changes)

## Backing Up to GitHub

1. **Initialize git repository** (if not already):
   ```bash
   cd ~/dotfiles
   git init
   git add .
   git commit -m "Initial dotfiles setup"
   ```

2. **Create a repository on GitHub** and push:
   ```bash
   git remote add origin <your-repo-url>
   git branch -M main
   git push -u origin main
   ```

3. **Keep it updated**:
   ```bash
   cd ~/dotfiles
   git add .
   git commit -m "Update configurations"
   git push
   ```

## Testing & Development

### Uninstalling for Testing

Use the uninstall script to remove configurations and test fresh installations:

```bash
bash ~/dotfiles/scripts/uninstall.sh
```

The script will interactively ask you what to remove:
- Symlinks (`~/.zshrc`, `~/.gitconfig`) - automatically removed
- Oh My Zsh and Spaceship theme - optional
- NVM directory - optional
- fzf configuration - optional
- macOS settings reset to defaults - optional

**What it keeps:**
- Homebrew and all installed packages
- The `~/dotfiles` directory itself
- Any `.backup` files (for safety)

**Quick test cycle:**
```bash
./bootstrap.sh              # Install
# ... test your setup ...
bash scripts/uninstall.sh   # Clean up
./bootstrap.sh              # Install again
```

### Complete Cleanup

To remove **everything** including Homebrew packages:

```bash
# 1. Uninstall dotfiles (answer 'y' to all prompts)
bash scripts/uninstall.sh

# 2. Remove packages from Brewfile
brew bundle cleanup --file=~/dotfiles/Brewfile --force

# 3. (Optional) Completely uninstall Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

## Troubleshooting

### Symlinks Not Working
If symlinks fail, check:
1. Backup files were created (`.backup` suffix)
2. You have write permissions to your home directory
3. Re-run bootstrap: `./bootstrap.sh`

### Spaceship Theme Not Loading
1. Check if Oh My Zsh is installed: `ls ~/.oh-my-zsh`
2. Verify symlink exists: `ls -la ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme`
3. Re-run: `bash ~/dotfiles/scripts/install_spaceship.sh`

### Homebrew Packages Not Found
1. Ensure Homebrew is in PATH: `echo $PATH | grep homebrew`
2. Restart terminal
3. Run: `brew doctor`

## Notes

- Designed for macOS (tested on Apple Silicon)
- Some applications may require manual login after installation
- System preferences require Terminal to have Full Disk Access
- Review all scripts before running them
- Keep your Brewfile updated as you add/remove tools

## Features

- ✅ Automated installation of development tools
- ✅ Symlinked configuration (automatic sync)
- ✅ Custom macOS system preferences
- ✅ Beautiful Spaceship prompt with Git integration
- ✅ Fuzzy finding with fzf
- ✅ Smart autosuggestions and syntax highlighting
- ✅ Git configuration with useful aliases
- ✅ Modular and extensible design
- ✅ Comprehensive error handling
- ✅ Easy to version control and backup

## License

MIT
