#!/bin/bash

# Cleanup script for complete dotfiles reinstallation
# This removes all installed components to allow a fresh bootstrap

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_step() {
    echo ""
    echo "========================================="
    echo "  $1"
    echo "========================================="
    echo ""
}

# Warning message
echo ""
echo "========================================="
echo "  CLEANUP SCRIPT - COMPLETE UNINSTALL"
echo "========================================="
echo ""
echo "This script will remove:"
echo "  • All backup files (.backup, .pre-oh-my-zsh)"
echo "  • Oh My Zsh installation"
echo "  • NVM directory"
echo "  • pyenv directory"
echo "  • ZSH cache and session files"
echo "  • FZF configuration files"
echo "  • SSH config (will be replaced by dotfiles)"
echo "  • VSCodium/Cursor settings (will be replaced by dotfiles)"
echo "  • npm, cache, and build directories"
echo ""
echo "Files that will be KEPT:"
echo "  ✓ ~/.gitconfig (will be updated by bootstrap)"
echo "  ✓ ~/.zshrc (symlink to dotfiles)"
echo "  ✓ ~/.gitignore_global (symlink to dotfiles)"
echo "  ✓ ~/.ssh/id_* (SSH keys)"
echo "  ✓ ~/.ssh/known_hosts"
echo "  ✓ ~/.zsh_history (command history)"
echo "  ✓ ~/.claude* (Claude Code settings)"
echo "  ✓ Homebrew and all packages (run uninstall.sh first if you want to remove these)"
echo ""
read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

# Step 1: Remove backup files
print_step "Step 1: Removing backup files"
if [ -f ~/.gitconfig.backup ]; then
    rm ~/.gitconfig.backup
    print_success "Removed ~/.gitconfig.backup"
fi

if [ -f ~/.zshrc.backup ]; then
    rm ~/.zshrc.backup
    print_success "Removed ~/.zshrc.backup"
fi

# Remove all .pre-oh-my-zsh files
for file in ~/.zshrc.pre-oh-my-zsh*; do
    if [ -f "$file" ]; then
        rm "$file"
        print_success "Removed $file"
    fi
done

# Step 2: Remove ZSH cache and session files
print_step "Step 2: Removing ZSH cache files"
if [ -d ~/.zsh_sessions ]; then
    rm -rf ~/.zsh_sessions
    print_success "Removed ~/.zsh_sessions"
fi

for file in ~/.zcompdump-*; do
    if [ -f "$file" ]; then
        rm "$file"
        print_success "Removed $file"
    fi
done

if [ -f ~/.z ]; then
    rm ~/.z
    print_success "Removed ~/.z (directory jump database)"
fi

# Step 3: Remove Oh My Zsh
print_step "Step 3: Removing Oh My Zsh"
if [ -d ~/.oh-my-zsh ]; then
    rm -rf ~/.oh-my-zsh
    print_success "Removed ~/.oh-my-zsh"
else
    print_warning "Oh My Zsh not found, skipping"
fi

# Step 4: Remove NVM
print_step "Step 4: Removing NVM directory"
if [ -d ~/.nvm ]; then
    rm -rf ~/.nvm
    print_success "Removed ~/.nvm"
else
    print_warning "NVM directory not found, skipping"
fi

# Step 5: Remove pyenv
print_step "Step 5: Removing pyenv directory"
if [ -d ~/.pyenv ]; then
    rm -rf ~/.pyenv
    print_success "Removed ~/.pyenv"
else
    print_warning "pyenv directory not found, skipping"
fi

# Step 6: Remove FZF config files
print_step "Step 6: Removing FZF configuration"
if [ -f ~/.fzf.bash ]; then
    rm ~/.fzf.bash
    print_success "Removed ~/.fzf.bash"
fi

if [ -f ~/.fzf.zsh ]; then
    rm ~/.fzf.zsh
    print_success "Removed ~/.fzf.zsh"
fi

# Step 7: Remove npm cache
print_step "Step 7: Removing npm cache"
if [ -d ~/.npm ]; then
    rm -rf ~/.npm
    print_success "Removed ~/.npm"
fi

# Step 8: Remove cache directories
print_step "Step 8: Removing cache directories"
if [ -d ~/.cache ]; then
    rm -rf ~/.cache
    print_success "Removed ~/.cache"
fi

# Step 9: Remove VSCode-OSS (VSCodium old settings)
print_step "Step 9: Removing VSCode-OSS directory"
if [ -d ~/.vscode-oss ]; then
    rm -rf ~/.vscode-oss
    print_success "Removed ~/.vscode-oss"
fi

# Step 10: Remove old SSH config (will be replaced by dotfiles)
print_step "Step 10: Removing old SSH config"
if [ -f ~/.ssh/config ] && [ ! -L ~/.ssh/config ]; then
    # Create backup just in case
    if [ -f ~/.ssh/config ]; then
        cp ~/.ssh/config ~/.ssh/config.backup.$(date +%Y%m%d_%H%M%S)
        print_success "Backed up old SSH config"
    fi
    rm ~/.ssh/config
    print_success "Removed old SSH config (will be replaced by dotfiles)"
elif [ -L ~/.ssh/config ]; then
    print_warning "SSH config is already a symlink, skipping"
else
    print_warning "No SSH config found, skipping"
fi

# Step 11: Remove VSCodium settings symlink if it exists
print_step "Step 11: Removing editor settings symlinks"
VSCODIUM_SETTINGS="$HOME/Library/Application Support/VSCodium/User/settings.json"
if [ -L "$VSCODIUM_SETTINGS" ]; then
    rm "$VSCODIUM_SETTINGS"
    print_success "Removed VSCodium settings symlink"
elif [ -f "$VSCODIUM_SETTINGS" ]; then
    # Backup the file
    cp "$VSCODIUM_SETTINGS" "$VSCODIUM_SETTINGS.backup.$(date +%Y%m%d_%H%M%S)"
    rm "$VSCODIUM_SETTINGS"
    print_success "Backed up and removed VSCodium settings"
fi

CURSOR_SETTINGS="$HOME/Library/Application Support/Cursor/User/settings.json"
if [ -L "$CURSOR_SETTINGS" ]; then
    rm "$CURSOR_SETTINGS"
    print_success "Removed Cursor settings symlink"
elif [ -f "$CURSOR_SETTINGS" ]; then
    # Backup the file
    cp "$CURSOR_SETTINGS" "$CURSOR_SETTINGS.backup.$(date +%Y%m%d_%H%M%S)"
    rm "$CURSOR_SETTINGS"
    print_success "Backed up and removed Cursor settings"
fi

# Step 12: Remove Starship config if it's a symlink
print_step "Step 12: Removing Starship config symlink"
if [ -L ~/.config/starship.toml ]; then
    rm ~/.config/starship.toml
    print_success "Removed Starship config symlink"
elif [ -f ~/.config/starship.toml ]; then
    print_warning "Starship config exists but is not a symlink, keeping it"
fi

# Final summary
print_step "Cleanup Complete!"
echo ""
echo "Summary:"
echo "  ✓ Removed all backup files"
echo "  ✓ Removed ZSH cache and session files"
echo "  ✓ Removed Oh My Zsh"
echo "  ✓ Removed NVM directory"
echo "  ✓ Removed pyenv directory"
echo "  ✓ Removed FZF configuration"
echo "  ✓ Removed npm cache"
echo "  ✓ Removed cache directories"
echo "  ✓ Removed old configurations"
echo ""
echo "Preserved:"
echo "  ✓ ~/.zsh_history (command history)"
echo "  ✓ ~/.ssh/ directory and keys"
echo "  ✓ ~/.claude* (Claude Code settings)"
echo "  ✓ ~/.gitconfig (will be updated by bootstrap)"
echo "  ✓ Homebrew and packages"
echo ""
echo "Next steps:"
echo "  1. Review what was removed above"
echo "  2. Run: cd ~/Documents/Repositories/dotfiles"
echo "  3. Run: ./bootstrap.sh"
echo "  4. Restart your terminal when complete"
echo ""
