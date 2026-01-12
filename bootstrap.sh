#!/bin/bash

# Bootstrap script for setting up a new macOS machine
# Usage: ./bootstrap.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_error() {
    echo -e "${RED}✗ Error: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ Warning: $1${NC}"
}

print_step() {
    echo ""
    echo "========================================="
    echo "  $1"
    echo "========================================="
    echo ""
}

# Create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ]; then
        print_warning "Symlink already exists: $target"
        return 0
    fi

    if [ -f "$target" ] || [ -d "$target" ]; then
        print_warning "File exists, creating backup: ${target}.backup"
        mv "$target" "${target}.backup"
    fi

    ln -s "$source" "$target"
    print_success "Symlinked: $target -> $source"
}

print_step "MacBook Pro Setup - Dotfiles Bootstrap"

# Get the dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# Check if we're in the dotfiles directory
if [ ! -d "$DOTFILES_DIR" ]; then
    print_error "Dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

cd "$DOTFILES_DIR" || exit 1

# Step 1: Install Homebrew
print_step "Step 1: Installing Homebrew"
if ! bash "$DOTFILES_DIR/scripts/install_homebrew.sh"; then
    print_error "Failed to install Homebrew"
    exit 1
fi
print_success "Homebrew installation complete"

# Step 2: Install packages from Brewfile
print_step "Step 2: Installing packages from Brewfile"
if ! command -v brew &> /dev/null; then
    print_error "Homebrew not found in PATH"
    exit 1
fi

if ! brew bundle --file="$DOTFILES_DIR/Brewfile"; then
    print_error "Failed to install Homebrew packages"
    exit 1
fi
print_success "All Homebrew packages installed"

# Step 3: Install Oh My Zsh
print_step "Step 3: Installing Oh My Zsh"
if ! bash "$DOTFILES_DIR/scripts/install_ohmyzsh.sh"; then
    print_error "Failed to install Oh My Zsh"
    exit 1
fi
print_success "Oh My Zsh installation complete"

# Step 4: Install Spaceship theme
print_step "Step 4: Installing Spaceship theme"
if ! bash "$DOTFILES_DIR/scripts/install_spaceship.sh"; then
    print_error "Failed to install Spaceship theme"
    exit 1
fi
print_success "Spaceship theme installation complete"

# Step 5: Setup fzf
print_step "Step 5: Setting up fzf"
if command -v fzf &> /dev/null; then
    if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
        "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
        print_success "fzf configured"
    fi
else
    print_warning "fzf not found, skipping setup"
fi

# Step 6: Create symlinks for config files
print_step "Step 6: Creating symlinks for configuration files"

# Symlink .zshrc
if [ -f "$DOTFILES_DIR/config/.zshrc" ]; then
    create_symlink "$DOTFILES_DIR/config/.zshrc" "$HOME/.zshrc"
else
    print_warning ".zshrc not found in config directory"
fi

# Symlink .gitconfig
if [ -f "$DOTFILES_DIR/config/.gitconfig" ]; then
    create_symlink "$DOTFILES_DIR/config/.gitconfig" "$HOME/.gitconfig"
else
    print_warning ".gitconfig not found in config directory"
fi

# Symlink .gitignore_global
if [ -f "$DOTFILES_DIR/config/.gitignore_global" ]; then
    create_symlink "$DOTFILES_DIR/config/.gitignore_global" "$HOME/.gitignore_global"
else
    print_warning ".gitignore_global not found in config directory"
fi

print_success "Configuration files symlinked"

# Step 7: Setup NVM
print_step "Step 7: Setting up NVM"
if [ -d "$(brew --prefix)/opt/nvm" ]; then
    mkdir -p ~/.nvm
    print_success "NVM directory created"
    print_success "NVM configuration already included in .zshrc"
else
    print_warning "NVM not found"
fi

# Step 8: Setup pyenv
print_step "Step 8: Setting up pyenv"
if command -v pyenv &> /dev/null; then
    print_success "pyenv installed and configured"
    print_success "pyenv configuration already included in .zshrc"
else
    print_warning "pyenv not found"
fi

# Step 9: Configure macOS settings
print_step "Step 9: Configuring macOS settings"
if ! bash "$DOTFILES_DIR/scripts/configure_macos.sh"; then
    print_error "Failed to configure macOS settings"
    exit 1
fi
print_success "macOS configuration complete"

# Final message
print_step "Setup Complete!"
echo ""
echo "Configuration Summary:"
echo "  ✓ Homebrew and packages installed"
echo "  ✓ Oh My Zsh with Spaceship theme configured"
echo "  ✓ Configuration files symlinked to dotfiles/"
echo "  ✓ Development tools (git, node, python) configured"
echo "  ✓ macOS system preferences customized"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Your config files are now symlinked to ~/dotfiles/config/"
echo "  3. Any changes to ~/.zshrc or ~/.gitconfig will be tracked in your dotfiles"
echo "  4. Add custom aliases to ~/dotfiles/config/.zsh_aliases"
echo "  5. Add custom functions to ~/dotfiles/config/.zsh_functions"
echo ""
echo "Useful commands:"
echo "  • brew update && brew upgrade - Update Homebrew packages"
echo "  • omz update - Update Oh My Zsh"
echo "  • cd ~/dotfiles && git status - Check dotfiles changes"
echo ""
