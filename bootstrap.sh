#!/bin/bash

# Bootstrap script for setting up a new macOS machine
# Usage: ./bootstrap.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Cleanup on error
cleanup_on_error() {
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo ""
        print_error "Installation failed with exit code $exit_code"
        print_warning "Your system may be in an incomplete state"
        echo ""
        echo "To clean up and try again:"
        echo "  1. Review the error messages above"
        echo "  2. Run: bash $DOTFILES_DIR/scripts/uninstall.sh"
        echo "  3. Fix any issues and re-run: ./bootstrap.sh"
        echo ""
    fi
}

trap cleanup_on_error EXIT

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

# Get the dotfiles directory (use script's actual location)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

echo "Using dotfiles from: $DOTFILES_DIR"

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

# Step 4: Setup Starship prompt
print_step "Step 4: Setting up Starship prompt"
if command -v starship &> /dev/null; then
    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"

    # Symlink Starship config
    if [ -f "$DOTFILES_DIR/config/starship.toml" ]; then
        create_symlink "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
        print_success "Starship configuration symlinked"
    else
        print_warning "starship.toml not found in config directory"
    fi
else
    print_warning "Starship not installed, skipping configuration"
fi

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

# Copy .gitconfig (don't symlink to avoid committing personal info)
if [ -f "$DOTFILES_DIR/config/.gitconfig" ]; then
    if [ -f "$HOME/.gitconfig" ]; then
        print_warning "File exists, creating backup: $HOME/.gitconfig.backup"
        mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
    fi
    cp "$DOTFILES_DIR/config/.gitconfig" "$HOME/.gitconfig"
    print_success "Copied: $HOME/.gitconfig (not symlinked to preserve privacy)"
else
    print_warning ".gitconfig not found in config directory"
fi

# Symlink .gitignore_global
if [ -f "$DOTFILES_DIR/config/.gitignore_global" ]; then
    create_symlink "$DOTFILES_DIR/config/.gitignore_global" "$HOME/.gitignore_global"
else
    print_warning ".gitignore_global not found in config directory"
fi

# Setup SSH configuration
if [ -f "$DOTFILES_DIR/config/ssh_config" ]; then
    # Create .ssh directory if it doesn't exist
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    # Create sockets directory for SSH connection reuse
    mkdir -p "$HOME/.ssh/sockets"

    # Symlink SSH config
    create_symlink "$DOTFILES_DIR/config/ssh_config" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
else
    print_warning "ssh_config not found in config directory"
fi

# Setup VSCodium settings
if [ -f "$DOTFILES_DIR/config/vscodium-settings.json" ]; then
    VSCODIUM_USER_DIR="$HOME/Library/Application Support/VSCodium/User"
    if [ -d "$VSCODIUM_USER_DIR" ]; then
        create_symlink "$DOTFILES_DIR/config/vscodium-settings.json" "$VSCODIUM_USER_DIR/settings.json"
        print_success "VSCodium settings symlinked"
    else
        print_warning "VSCodium not found, skipping settings sync"
    fi
fi

# Setup Cursor settings
if [ -f "$DOTFILES_DIR/config/cursor-settings.json" ]; then
    CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
    if [ -d "$CURSOR_USER_DIR" ]; then
        create_symlink "$DOTFILES_DIR/config/cursor-settings.json" "$CURSOR_USER_DIR/settings.json"
        print_success "Cursor settings symlinked"
    else
        print_warning "Cursor not found, skipping settings sync"
    fi
fi

print_success "Configuration files symlinked"

# Step 7: Configure Git user information
print_step "Step 7: Configuring Git user information"

echo "Please enter your Git configuration:"
read -p "Git user name: " git_name
read -p "Git email: " git_email

if [ -n "$git_name" ] && [ -n "$git_email" ]; then
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    print_success "Git user configured: $git_name <$git_email>"
else
    print_warning "Git user configuration skipped"
fi

# Step 8: Setup NVM
print_step "Step 8: Setting up NVM"
if [ -d "$(brew --prefix)/opt/nvm" ]; then
    mkdir -p ~/.nvm
    print_success "NVM directory created"
    print_success "NVM configuration already included in .zshrc"
else
    print_warning "NVM not found"
fi

# Step 9: Setup pyenv
print_step "Step 9: Setting up pyenv"
if command -v pyenv &> /dev/null; then
    print_success "pyenv installed and configured"
    print_success "pyenv configuration already included in .zshrc"
else
    print_warning "pyenv not found"
fi

# Step 10: Configure macOS settings
print_step "Step 10: Configuring macOS settings"
if ! bash "$DOTFILES_DIR/scripts/configure_macos.sh"; then
    print_error "Failed to configure macOS settings"
    exit 1
fi
print_success "macOS configuration complete"

# Step 11: Validate installation
print_step "Step 11: Validating Installation"
validation_failed=0

# Check critical tools
if ! command -v brew &> /dev/null; then
    print_error "Homebrew not found"
    validation_failed=1
else
    print_success "Homebrew installed"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_error "Oh My Zsh not found"
    validation_failed=1
else
    print_success "Oh My Zsh installed"
fi

if [ ! -L "$HOME/.zshrc" ]; then
    print_warning ".zshrc not symlinked"
else
    print_success ".zshrc symlinked"
fi

# Check optional tools
command -v fzf &> /dev/null && print_success "fzf installed" || print_warning "fzf not found"
command -v git &> /dev/null && print_success "git installed" || print_warning "git not found"
command -v nvm &> /dev/null && print_success "nvm installed" || print_warning "nvm not found"
command -v pyenv &> /dev/null && print_success "pyenv installed" || print_warning "pyenv not found"

if [ $validation_failed -eq 1 ]; then
    print_error "Installation validation failed. Please review errors above."
    exit 1
fi

print_success "Installation validation complete"

# Final message
print_step "Setup Complete!"
echo ""
echo "Configuration Summary:"
echo "  ✓ Homebrew and packages installed"
echo "  ✓ Oh My Zsh with Spaceship theme configured"
echo "  ✓ Configuration files symlinked to $DOTFILES_DIR"
echo "  ✓ Development tools (git, node, python) configured"
echo "  ✓ macOS system preferences customized"
echo ""
echo "Your dotfiles location: $DOTFILES_DIR"
echo "Access it anytime with: dotfiles (alias) or \$DOTFILES (variable)"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Your config files are now symlinked to $DOTFILES_DIR/config/"
echo "  3. Any changes to ~/.zshrc or ~/.gitconfig will be tracked in your dotfiles"
echo "  4. Add custom aliases using: aliases (opens in editor)"
echo "  5. Add custom functions using: functions (opens in editor)"
echo ""
echo "Useful commands:"
echo "  • brew update && brew upgrade - Update Homebrew packages"
echo "  • omz update - Update Oh My Zsh"
echo "  • dotfiles - Navigate to your dotfiles directory"
echo "  • cd \$DOTFILES && git status - Check dotfiles changes"
echo ""
