# Dotfiles for macOS Setup

A comprehensive collection of dotfiles and scripts to quickly set up a new MacBook Pro with essential tools, applications, and personalized system preferences.

## Quick Start

### First Time Setup

1. **Clone this repository** to your new Mac (you can use any directory):
   ```bash
   git clone https://github.com/elmartinez85/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

   Or use your preferred location:
   ```bash
   git clone https://github.com/elmartinez85/dotfiles.git ~/Documents/Repositories/dotfiles
   cd ~/Documents/Repositories/dotfiles
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
- **Calibre** - E-book library management
- **Cursor** - AI-powered code editor
- **Discord** - Voice, video, and text communication platform
- **Helium Browser** - Floating browser window
- **Mullvad Browser** - Privacy-focused browser
- **Obsidian** - Knowledge base and note-taking app
- **PearCleaner** - Mac cleaning utility
- **Rectangle** - Window management tool
- **AeroSpace** - i3-inspired tiling window manager for macOS
- **Slack** - Team collaboration and messaging
- **VSCodium** - VS Code without telemetry

### Shell Configuration
- **Oh My Zsh** - Framework for managing zsh configuration
- **Starship** - Fast, customizable, cross-shell prompt with powerline-style theme
- **1Password SSH Agent** - Secure SSH key management via 1Password
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
├── bootstrap.sh                     # Main setup script with symlink strategy
├── Brewfile                         # Homebrew package definitions
├── README.md                        # This file
├── config/
│   ├── .gitconfig                  # Git configuration (copied to ~/.gitconfig)
│   ├── .gitignore_global           # Global git ignores (symlinked)
│   ├── .zshrc                      # Zsh configuration with 1Password SSH agent (symlinked to ~/.zshrc)
│   ├── .zsh_aliases                # Custom aliases
│   ├── .zsh_functions              # Custom functions
│   ├── ssh_config                  # SSH configuration (symlinked to ~/.ssh/config)
│   ├── ssh_config.local.example    # Example local SSH hosts (not symlinked)
│   ├── starship.toml               # Starship powerline prompt configuration (symlinked to ~/.config/starship.toml)
│   ├── aerospace.toml              # AeroSpace window manager configuration (symlinked to ~/.aerospace.toml)
│   ├── vscodium-settings.json      # VSCodium settings (symlinked)
│   ├── vscodium-extensions.txt     # VSCodium extensions to auto-install
│   └── cursor-settings.json        # Cursor settings (symlinked)
└── scripts/
    ├── configure_macos.sh          # macOS system preferences
    ├── install_homebrew.sh         # Homebrew installation
    ├── install_ohmyzsh.sh          # Oh My Zsh installation
    └── uninstall.sh                # Uninstall script for testing
```

## Symlink Strategy

This dotfiles setup uses **symbolic links** for most configuration files. The bootstrap script automatically detects where you cloned the repository and creates symlinks accordingly:

- `~/.zshrc` → `$DOTFILES/config/.zshrc` (symlinked)
- `~/.gitconfig` ← `$DOTFILES/config/.gitconfig` (copied, not symlinked)
- `~/.gitignore_global` → `$DOTFILES/config/.gitignore_global` (symlinked)
- `~/.ssh/config` → `$DOTFILES/config/ssh_config` (symlinked)
- `~/.config/starship.toml` → `$DOTFILES/config/starship.toml` (symlinked)
- `~/.aerospace.toml` → `$DOTFILES/config/aerospace.toml` (symlinked)
- `~/Library/Application Support/VSCodium/User/settings.json` → `$DOTFILES/config/vscodium-settings.json` (symlinked)
- `~/Library/Application Support/Cursor/User/settings.json` → `$DOTFILES/config/cursor-settings.json` (symlinked)

**Why `.gitconfig` is copied instead of symlinked:**
- Prevents your personal name and email from being committed to the repository
- Keeps sensitive information local to your machine
- The bootstrap script prompts for your info and sets it automatically

**Benefits:**
- Works from any directory location (no hardcoded paths!)
- Edit symlinked configuration files from anywhere
- Changes to symlinked files are automatically tracked in your dotfiles repository
- Privacy-first: personal Git info stays local
- Use `$DOTFILES` environment variable to reference your dotfiles location
- SSH config with 1Password integration for secure key management
- Local SSH hosts in `~/.ssh/config.local` (gitignored, for private servers)
- VSCodium extensions automatically installed via `codium` CLI
- Editor settings synced across machines

## Customization

### Adding Custom Aliases

Edit using the `aliases` command (opens in your editor), or directly:
```bash
codium $DOTFILES/config/.zsh_aliases
```

Example aliases:
```bash
alias ll="ls -lah"
alias ..="cd .."
alias gs="git status"
```

### Adding Custom Functions

Edit using the `functions` command (opens in your editor), or directly:
```bash
codium $DOTFILES/config/.zsh_functions
```

Example function:
```bash
mkcd() {
    mkdir -p "$1" && cd "$1"
}
```

### Modifying Git Configuration

Your Git name and email are configured during bootstrap setup (not stored in the repository). To change other Git settings, edit:
```bash
codium $DOTFILES/config/.gitconfig
```

You can modify:
- Git aliases
- Default editor
- Merge/diff tools
- Other Git preferences

### Customizing Starship Prompt

Edit the Starship configuration file:
```bash
codium $DOTFILES/config/starship.toml
```

See [Starship documentation](https://starship.rs/config/) for all configuration options. You can customize:
- Prompt symbols and colors
- Git status display
- Language version indicators
- Custom modules and formats

### Customizing AeroSpace Window Manager

Edit the AeroSpace configuration file:
```bash
codium $DOTFILES/config/aerospace.toml
```

**Essential Keybindings (defaults):**

**Focus windows:**
- `Alt + h/j/k/l` - Move focus left/down/up/right (Vim-style)

**Move windows:**
- `Alt + Shift + h/j/k/l` - Move window left/down/up/right

**Switch workspaces:**
- `Alt + 1/2/3...` - Switch to workspace 1, 2, 3, etc.

**Move window to workspace:**
- `Alt + Shift + 1/2/3...` - Move window to workspace

**Layouts:**
- `Alt + f` - Toggle fullscreen
- `Alt + s` - Vertical split
- `Alt + w` - Horizontal split
- `Alt + e` - Default tiling layout
- `Alt + Shift + Space` - Toggle floating/tiling

**Resize mode:**
- `Alt + r` - Enter resize mode
  - Then use `h/j/k/l` to resize
  - Press `Enter` or `Esc` to exit resize mode

**Other:**
- `Alt + Shift + b` - Balance window sizes
- `Alt + Shift + c` - Reload configuration
- `Alt + Shift + q` - Close window

**Tips:**
- Start with 3-5 workspaces and adjust based on your workflow
- Assign specific apps to workspaces (uncomment examples in config)
- Adjust gaps in the config file for tighter/looser window spacing
- Consider changing the main modifier from `alt` to `cmd` if needed

See [AeroSpace documentation](https://github.com/nikitabobko/AeroSpace) for advanced configuration.

### Adding Private SSH Hosts

The SSH config uses 1Password for secure key management and supports local host definitions:

1. **Edit your local SSH hosts** (gitignored, won't be committed):
   ```bash
   codium ~/.ssh/config.local
   ```

2. **Add a host**:
   ```
   Host myserver
       HostName 192.168.1.100
       User yourusername
   ```

3. **Connect**:
   ```bash
   ssh myserver
   ```

**How it works:**
- `~/.ssh/config` is symlinked to `$DOTFILES/config/ssh_config` (tracked in git)
- `~/.ssh/config` includes `~/.ssh/config.local` (gitignored, private)
- SSH keys are managed by 1Password agent via `SSH_AUTH_SOCK` environment variable
- All tools (git, rsync, scp) use 1Password keys automatically

**To add a public key to a remote server:**
```bash
# Show your public keys from 1Password
ssh-add -L

# Copy a key to remote server
ssh-copy-id user@hostname
```

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

### Update Starship
Starship is updated via Homebrew:
```bash
brew upgrade starship
```

### Add New Homebrew Packages
1. Edit the `Brewfile`:
   ```bash
   codium $DOTFILES/Brewfile
   ```
2. Add packages using `brew "package-name"` or `cask "app-name"`
3. Run:
   ```bash
   brew bundle --file=$DOTFILES/Brewfile
   ```
   Or use the convenient alias:
   ```bash
   brewdump  # Updates Brewfile with currently installed packages
   ```

## Useful Commands

### General
- `brewup` - Update all Homebrew packages (alias for brew update && brew upgrade && brew cleanup)
- `omz update` - Update Oh My Zsh
- `dotfiles` - Navigate to your dotfiles directory
- `cd $DOTFILES && git status` - Check for uncommitted dotfile changes
- `aliases` - Edit your custom aliases
- `functions` - Edit your custom functions

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

This repository is already set up for GitHub! To keep your changes synced:

```bash
dotfiles           # Navigate to dotfiles directory
git add .
git commit -m "Update configurations"
git push
```

Or use the convenient workflow:
```bash
cd $DOTFILES && git status  # Check what changed
git add .                    # Stage changes
git commit -m "Your message" # Commit
git push                     # Push to GitHub
```

## Testing & Development

### Uninstalling for Testing

Use the uninstall script to remove configurations and test fresh installations:

```bash
bash $DOTFILES/scripts/uninstall.sh
```

The script will interactively ask you what to remove:
- Symlinks (`~/.zshrc`, `~/.gitconfig`) - automatically removed
- Oh My Zsh - optional
- NVM directory - optional
- fzf configuration - optional
- macOS settings reset to defaults - optional

**What it keeps:**
- Homebrew and all installed packages
- Your dotfiles directory
- Any `.backup` files (for safety)

**Quick test cycle:**
```bash
dotfiles                    # Navigate to dotfiles
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
brew bundle cleanup --file=$DOTFILES/Brewfile --force

# 3. (Optional) Completely uninstall Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

## Troubleshooting

### Symlinks Not Working
If symlinks fail, check:
1. Backup files were created (`.backup` suffix)
2. You have write permissions to your home directory
3. Re-run bootstrap: `./bootstrap.sh`

### Starship Prompt Not Loading
1. Check if Starship is installed: `starship --version`
2. Verify configuration exists: `ls -la ~/.config/starship.toml`
3. Re-install: `brew install starship` and re-run `./bootstrap.sh`

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
- ✅ Blazing-fast Starship powerline prompt with Git integration
- ✅ Fuzzy finding with fzf
- ✅ Smart autosuggestions and syntax highlighting
- ✅ Git configuration with useful aliases
- ✅ SSH configuration with 1Password agent integration
- ✅ Local SSH hosts support (gitignored for privacy)
- ✅ VSCodium and Cursor settings sync
- ✅ Automatic VSCodium extension installation
- ✅ Enhanced shell history management (50k commands, deduplication)
- ✅ Post-install validation
- ✅ Error recovery with cleanup guidance
- ✅ Modular and extensible design
- ✅ Comprehensive error handling
- ✅ Easy to version control and backup

## License

MIT
