#!/bin/bash

set -e  # Exit on error

# Uninstall script for dotfiles
# This removes symlinks and restores backups for testing purposes
# Usage: bash scripts/uninstall.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
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

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_step() {
    echo ""
    echo "========================================="
    echo "  $1"
    echo "========================================="
    echo ""
}

# Function to remove symlink and restore backup
remove_symlink() {
    local target="$1"
    local backup="${target}.backup"

    if [ -L "$target" ]; then
        rm "$target"
        print_success "Removed symlink: $target"

        if [ -f "$backup" ] || [ -d "$backup" ]; then
            mv "$backup" "$target"
            print_success "Restored backup: $backup -> $target"
        fi
    elif [ -f "$target" ] || [ -d "$target" ]; then
        print_warning "$target exists but is not a symlink (not removing)"
    else
        print_info "$target does not exist (skipping)"
    fi
}

# Confirmation prompt
print_step "Dotfiles Uninstall Script"
echo "This script will:"
echo "  • Remove symlinks created by bootstrap.sh"
echo "  • Restore any .backup files"
echo "  • Optionally remove Oh My Zsh"
echo "  • Optionally reset macOS settings to defaults"
echo ""
echo "This will NOT:"
echo "  • Uninstall Homebrew or packages"
echo "  • Delete the dotfiles directory"
echo ""
read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Remove symlinks
print_step "Removing Symlinks"
remove_symlink "$HOME/.zshrc"
remove_symlink "$HOME/.gitconfig"
remove_symlink "$HOME/.gitignore_global"

# Ask about Oh My Zsh
echo ""
read -p "Remove Oh My Zsh? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -d "$HOME/.oh-my-zsh" ]; then
        rm -rf "$HOME/.oh-my-zsh"
        print_success "Removed Oh My Zsh"
    else
        print_info "Oh My Zsh not found"
    fi
fi

# Ask about NVM directory
echo ""
read -p "Remove NVM directory (~/.nvm)? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -d "$HOME/.nvm" ]; then
        rm -rf "$HOME/.nvm"
        print_success "Removed ~/.nvm directory"
    else
        print_info "~/.nvm directory not found"
    fi
fi

# Ask about fzf
echo ""
read -p "Remove fzf configuration (~/.fzf.zsh)? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "$HOME/.fzf.zsh" ]; then
        rm "$HOME/.fzf.zsh"
        print_success "Removed ~/.fzf.zsh"
    else
        print_info "~/.fzf.zsh not found"
    fi
    if [ -f "$HOME/.fzf.bash" ]; then
        rm "$HOME/.fzf.bash"
        print_success "Removed ~/.fzf.bash"
    fi
fi

# Ask about Homebrew tap cleanup
echo ""
read -p "Clean up deprecated Homebrew taps? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_step "Cleaning Homebrew Taps"

    # Untap deprecated taps if they exist
    if brew tap | grep -q "homebrew/bundle"; then
        brew untap homebrew/bundle 2>/dev/null && print_success "Untapped homebrew/bundle" || print_info "homebrew/bundle already removed"
    fi

    if brew tap | grep -q "homebrew/cask-fonts"; then
        brew untap homebrew/cask-fonts 2>/dev/null && print_success "Untapped homebrew/cask-fonts" || print_info "homebrew/cask-fonts already removed"
    fi

    print_info "Note: homebrew/core and homebrew/cask are built-in and don't need to be untapped"
fi

# Ask about macOS settings reset
echo ""
read -p "Reset macOS settings to defaults? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_step "Resetting macOS Settings"

    # Finder
    defaults write com.apple.finder AppleShowAllFiles -bool false
    defaults write NSGlobalDomain AppleShowAllExtensions -bool false
    print_success "Finder: hidden files and extensions disabled"

    # Screenshots (reset to Desktop)
    defaults write com.apple.screencapture location "$HOME/Desktop"
    defaults write com.apple.screencapture disable-shadow -bool false
    print_success "Screenshots: reset to Desktop with shadows"

    # Dock (reset to defaults)
    defaults write com.apple.dock autohide -bool false
    defaults write com.apple.dock tilesize -int 64
    defaults write com.apple.dock orientation -string "bottom"
    defaults delete com.apple.dock autohide-time-modifier 2>/dev/null || true
    defaults delete com.apple.dock autohide-delay 2>/dev/null || true
    print_success "Dock: reset to defaults (no auto-hide, bottom position)"

    # Trackpad
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
    print_success "Trackpad: natural scrolling enabled"

    # Keyboard
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true
    defaults write NSGlobalDomain KeyRepeat -int 6
    defaults write NSGlobalDomain InitialKeyRepeat -int 25
    print_success "Keyboard: press-and-hold enabled, normal key repeat"

    # Restart affected apps
    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true
    killall SystemUIServer 2>/dev/null || true
    print_success "Restarted system applications"
fi

# Final message
print_step "Uninstall Complete"
echo ""
echo "What was done:"
echo "  ✓ Removed dotfiles symlinks"
echo "  ✓ Restored any backup files"
echo ""
echo "What remains:"
echo "  • Homebrew and installed packages (use 'brew uninstall' manually)"
echo "  • ~/dotfiles directory (delete manually if desired)"
echo "  • Backup files (*.backup) in your home directory"
echo ""
echo "To completely remove Homebrew packages:"
echo "  brew bundle cleanup --file=~/dotfiles/Brewfile --force"
echo ""
echo "To reinstall dotfiles:"
echo "  cd ~/dotfiles && ./bootstrap.sh"
echo ""
