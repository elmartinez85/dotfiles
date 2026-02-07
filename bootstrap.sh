#!/bin/bash

# Bootstrap script for setting up a new macOS machine with profile support
# Usage: ./bootstrap.sh --profile [personal|work]

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Error and warning tracking
ERRORS=()
WARNINGS=()

# Cleanup on error
cleanup_on_error() {
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo ""
        print_error "Installation failed with exit code $exit_code"
        print_warning "Your system may be in an incomplete state"
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

# Error tracking helpers
add_error() {
    ERRORS+=("$1")
    print_error "$1"
}

add_warning() {
    WARNINGS+=("$1")
    print_warning "$1"
}

# Print final summary
print_summary() {
    echo ""
    echo "========================================="
    echo "  Installation Summary"
    echo "========================================="
    echo ""

    if [ ${#WARNINGS[@]} -gt 0 ]; then
        print_warning "Completed with ${#WARNINGS[@]} warning(s):"
        for warning in "${WARNINGS[@]}"; do
            echo "  ⚠ $warning"
        done
        echo ""
    fi

    if [ ${#ERRORS[@]} -gt 0 ]; then
        print_error "Completed with ${#ERRORS[@]} error(s):"
        for error in "${ERRORS[@]}"; do
            echo "  ✗ $error"
        done
        echo ""
        return 1
    fi

    if [ ${#WARNINGS[@]} -eq 0 ] && [ ${#ERRORS[@]} -eq 0 ]; then
        print_success "Installation completed successfully with no issues!"
    fi

    return 0
}

# Pre-flight validation
validate_dotfiles_structure() {
    local profile=$1
    local dotfiles_dir=$2
    local missing_files=()

    print_step "Pre-flight Validation"
    print_info "Checking dotfiles repository structure..."

    # Check base directory exists
    if [ ! -d "$dotfiles_dir/base" ]; then
        missing_files+=("base/ directory")
    fi

    # Check required base files
    local base_files=(
        "base/.zshrc"
        "base/.zsh_aliases"
        "base/.zsh_functions"
        "base/.gitconfig"
        "base/.gitignore_global"
        "base/Brewfile.base"
        "base/starship.toml"
        "base/aerospace-base.toml"
    )

    for file in "${base_files[@]}"; do
        if [ ! -f "$dotfiles_dir/$file" ]; then
            missing_files+=("$file")
        fi
    done

    # Check profiles directory exists
    if [ ! -d "$dotfiles_dir/profiles" ]; then
        missing_files+=("profiles/ directory")
    fi

    # Check profile-specific directory exists
    if [ ! -d "$dotfiles_dir/profiles/$profile" ]; then
        missing_files+=("profiles/$profile/ directory")
    fi

    # Check required profile files
    local profile_files=(
        "profiles/$profile/.gitconfig"
        "profiles/$profile/Brewfile.additions"
        "profiles/$profile/ssh_config.additions"
        "profiles/$profile/aerospace-apps.toml"
        "profiles/$profile/AWS_CONFIG_README.md"
    )

    for file in "${profile_files[@]}"; do
        if [ ! -f "$dotfiles_dir/$file" ]; then
            missing_files+=("$file")
        fi
    done

    # Check work profile specific files
    if [[ "$profile" == "work" ]]; then
        if [ ! -d "$dotfiles_dir/base/espanso" ]; then
            missing_files+=("base/espanso/ directory")
        fi
        if [ ! -d "$dotfiles_dir/profiles/work/espanso" ]; then
            missing_files+=("profiles/work/espanso/ directory")
        fi
    fi

    # Check config directory
    if [ ! -d "$dotfiles_dir/config" ]; then
        missing_files+=("config/ directory")
    fi

    # Report results
    if [ ${#missing_files[@]} -gt 0 ]; then
        print_error "Dotfiles repository structure is incomplete!"
        echo ""
        echo "Missing required files/directories:"
        for file in "${missing_files[@]}"; do
            echo "  - $file"
        done
        echo ""
        print_info "This could mean:"
        echo "  1. The repository was not cloned completely"
        echo "  2. You're running the script from the wrong directory"
        echo "  3. The repository is corrupted or on the wrong branch"
        echo ""
        print_info "Current directory: $(pwd)"
        print_info "Detected dotfiles directory: $dotfiles_dir"
        echo ""
        return 1
    fi

    print_success "All required files found!"
    return 0
}

# Create symlink helper
create_symlink() {
    local source=$1
    local target=$2

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        print_warning "$target exists (not a symlink), backing up to ${target}.backup"
        mv "$target" "${target}.backup"
    fi

    mkdir -p "$(dirname "$target")"
    ln -sf "$source" "$target"
    print_success "Symlinked: $target → $source"
}

# System requirements check
check_system_requirements() {
    print_step "System Requirements Check"
    print_info "Validating system prerequisites..."

    local requirements_met=true

    # Check 1: macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script only works on macOS"
        print_info "Detected OS: $OSTYPE"
        return 1
    fi
    print_success "Running on macOS"

    # Check 2: macOS version (require 12.0+)
    local macos_version=$(sw_vers -productVersion)
    local macos_major=$(echo "$macos_version" | cut -d. -f1)
    print_info "macOS version: $macos_version"

    if [[ $macos_major -lt 12 ]]; then
        print_error "macOS 12.0 (Monterey) or higher required"
        return 1
    fi
    print_success "macOS version compatible"

    # Check 3: Xcode Command Line Tools
    if ! xcode-select -p &> /dev/null; then
        print_warning "Xcode Command Line Tools not installed"
        print_info "These are required for git, make, and other build tools"
        echo ""
        read -p "Install Xcode Command Line Tools now? [Y/n] " -n 1 -r
        echo ""

        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            print_info "Starting Xcode Command Line Tools installation..."
            xcode-select --install
            echo ""
            print_warning "Please complete the installation dialog, then run this script again"
            return 1
        else
            print_error "Xcode Command Line Tools required to continue"
            return 1
        fi
    fi
    print_success "Xcode Command Line Tools installed"

    # Check 4: Internet connectivity
    if ! ping -c 1 -W 2 google.com &> /dev/null; then
        print_warning "No internet connection detected"
        print_info "Internet is required to download Homebrew and packages"
        echo ""
        read -p "Continue anyway? [y/N] " -n 1 -r
        echo ""

        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Please connect to the internet and try again"
            return 1
        fi
        print_warning "Continuing without internet (installation may fail)"
    else
        print_success "Internet connection available"
    fi

    # Check 5: Disk space (need at least 5GB)
    local available_space=$(df -g / | tail -1 | awk '{print $4}')
    print_info "Available disk space: ${available_space}GB"

    if [[ $available_space -lt 5 ]]; then
        print_error "Insufficient disk space (need at least 5GB free)"
        print_info "Please free up disk space and try again"
        return 1
    fi
    print_success "Sufficient disk space available"

    # Check 6: 1Password SSH agent (optional but recommended)
    local onepassword_socket="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    if [ ! -S "$onepassword_socket" ]; then
        print_warning "1Password SSH agent not detected"
        print_info "SSH agent path: $onepassword_socket"
        print_info "SSH key management will not work without 1Password"
        echo ""
        read -p "Continue without 1Password? [y/N] " -n 1 -r
        echo ""

        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Please install and configure 1Password, then try again"
            print_info "Download: https://1password.com/downloads/mac/"
            return 1
        fi
        print_warning "Continuing without 1Password (SSH keys will need manual setup)"
    else
        print_success "1Password SSH agent detected"
    fi

    echo ""
    print_success "All system requirements validated!"
    return 0
}

# Parse arguments
PROFILE=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --profile)
            PROFILE="$2"
            shift 2
            ;;
        *)
            echo "Usage: $0 --profile [personal|work]"
            echo ""
            echo "Profiles:"
            echo "  personal  - Personal machine setup (includes Discord, Cursor, Mullvad, etc.)"
            echo "  work      - Work machine setup (includes Chrome, Firefox Dev, Espanso, etc.)"
            exit 1
            ;;
    esac
done

# Validate profile
if [[ "$PROFILE" != "personal" && "$PROFILE" != "work" ]]; then
    echo "Error: Profile must be 'personal' or 'work'"
    echo "Usage: $0 --profile [personal|work]"
    exit 1
fi

# Set up directories - auto-detect script location
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check system requirements before proceeding
if ! check_system_requirements; then
    exit 1
fi

# Validate repository structure before proceeding
if ! validate_dotfiles_structure "$PROFILE" "$DOTFILES_DIR"; then
    exit 1
fi

print_step "Dotfiles Setup - Profile: $PROFILE"
print_info "Dotfiles directory: $DOTFILES_DIR"
print_info "Active profile: $PROFILE"

# Save active profile
echo "$PROFILE" > "$DOTFILES_DIR/.profile_active"
print_success "Profile '$PROFILE' activated"

# Step 1: Install Homebrew
print_step "Step 1: Installing Homebrew"
if ! command -v brew &> /dev/null; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
    brew update
fi

# Step 2: Merge and install Brewfile
print_step "Step 2: Installing packages from Brewfile ($PROFILE profile)"

# Merge base Brewfile with profile additions
MERGED_BREWFILE="$DOTFILES_DIR/Brewfile"
cat "$DOTFILES_DIR/base/Brewfile.base" > "$MERGED_BREWFILE"
echo "" >> "$MERGED_BREWFILE"
echo "# Profile-specific additions ($PROFILE)" >> "$MERGED_BREWFILE"
cat "$DOTFILES_DIR/profiles/$PROFILE/Brewfile.additions" >> "$MERGED_BREWFILE"

print_info "Installing packages..."
if brew bundle --file="$MERGED_BREWFILE"; then
    print_success "All packages installed"
else
    add_warning "Some Homebrew packages failed to install"
    print_info "You can retry with: brew bundle --file=$MERGED_BREWFILE"
    echo ""
    read -p "Continue with configuration anyway? [Y/n] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_error "Installation aborted by user"
        exit 1
    fi
fi

# Step 2.1: Validate critical tools were installed
print_info "Validating critical tools..."
CRITICAL_TOOLS=("git" "zsh" "starship" "fzf" "bat" "eza" "rg" "nvim")
local missing_tools=()

for tool in "${CRITICAL_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        missing_tools+=("$tool")
    fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
    add_warning "Some critical tools were not installed: ${missing_tools[*]}"
    print_info "These tools are required for full functionality"
else
    print_success "All critical tools validated"
fi

# Step 2.5: Install Oh My Zsh
print_step "Step 2.5: Installing Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "Installing Oh My Zsh..."
    # Install Oh My Zsh in unattended mode (no shell change prompt)
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    print_success "Oh My Zsh installed"
else
    print_success "Oh My Zsh already installed"
fi

# Step 3: Setup Zsh configs
print_step "Step 3: Setting up Zsh configuration"
create_symlink "$DOTFILES_DIR/base/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/base/.zsh_aliases" "$HOME/.zsh_aliases"
create_symlink "$DOTFILES_DIR/base/.zsh_functions" "$HOME/.zsh_functions"

# Step 4: Setup Git config
print_step "Step 4: Setting up Git configuration"
create_symlink "$DOTFILES_DIR/base/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/profiles/$PROFILE/.gitconfig" "$HOME/.gitconfig.profile"
create_symlink "$DOTFILES_DIR/base/.gitignore_global" "$HOME/.gitignore_global"

print_warning "Remember to update your email in: $DOTFILES_DIR/profiles/$PROFILE/.gitconfig"

# Step 5: Setup SSH config
print_step "Step 5: Setting up SSH configuration"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Backup existing SSH config if it exists and is not a previous bootstrap config
SSH_CONFIG="$HOME/.ssh/config"
if [ -f "$SSH_CONFIG" ]; then
    # Check if it's a bootstrap-generated config (contains our marker)
    if ! grep -q "# SSH Configuration (Generated by bootstrap)" "$SSH_CONFIG"; then
        # This is a user's custom config, back it up
        BACKUP_FILE="${SSH_CONFIG}.backup-$(date +%Y%m%d-%H%M%S)"
        cp "$SSH_CONFIG" "$BACKUP_FILE"
        print_warning "Existing SSH config backed up to: $BACKUP_FILE"
    fi
fi

# Create SSH config with profile include
cat > "$SSH_CONFIG" << 'EOF'
# SSH Configuration (Generated by bootstrap)
# Base settings
Host *
    AddKeysToAgent yes
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Profile-specific hosts
Include ~/.ssh/config.profile
EOF

create_symlink "$DOTFILES_DIR/profiles/$PROFILE/ssh_config.additions" "$HOME/.ssh/config.profile"
chmod 600 "$SSH_CONFIG"
print_success "SSH configuration created"

# Step 6: Setup Starship prompt
print_step "Step 6: Setting up Starship prompt"
if command -v starship &> /dev/null; then
    mkdir -p "$HOME/.config"
    create_symlink "$DOTFILES_DIR/base/starship.toml" "$HOME/.config/starship.toml"
    print_success "Starship configuration symlinked"
else
    print_warning "Starship not installed, skipping configuration"
fi

# Step 7: Setup AeroSpace window manager
print_step "Step 7: Setting up AeroSpace"
if [ -d "/Applications/AeroSpace.app" ]; then
    # Merge base AeroSpace config with profile apps
    # Profile shortcuts are inserted at INSERTION_POINT_APP_SHORTCUTS marker
    # Workspace assignments are appended at the end
    AEROSPACE_CONFIG="$DOTFILES_DIR/config/aerospace.toml"
    PROFILE_APPS="$DOTFILES_DIR/profiles/$PROFILE/aerospace-apps.toml"

    # Extract app shortcuts (everything before workspace assignments)
    APP_SHORTCUTS=$(sed -n '1,/^# .*WORKSPACE AUTO-ASSIGNMENTS/{ /^# .*WORKSPACE AUTO-ASSIGNMENTS/!p; }' "$PROFILE_APPS")
    # Extract workspace assignments (everything after the marker)
    WORKSPACE_ASSIGNMENTS=$(sed -n '/^# .*WORKSPACE AUTO-ASSIGNMENTS/,$p' "$PROFILE_APPS")

    # Insert app shortcuts at placeholder and append workspace assignments
    sed "/# INSERTION_POINT_APP_SHORTCUTS/r /dev/stdin" "$DOTFILES_DIR/base/aerospace-base.toml" <<< "$APP_SHORTCUTS" > "$AEROSPACE_CONFIG"
    echo "" >> "$AEROSPACE_CONFIG"
    echo "$WORKSPACE_ASSIGNMENTS" >> "$AEROSPACE_CONFIG"

    create_symlink "$AEROSPACE_CONFIG" "$HOME/.aerospace.toml"
    print_success "AeroSpace configuration created for $PROFILE profile"
else
    print_warning "AeroSpace not installed, skipping configuration"
fi

# Step 8: Setup fzf
print_step "Step 8: Setting up fzf"
if command -v fzf &> /dev/null; then
    if [ ! -f "$HOME/.fzf.zsh" ]; then
        "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
        print_success "fzf shell integration installed"
    else
        print_success "fzf already configured"
    fi
else
    print_warning "fzf not installed, skipping configuration"
fi

# Step 9: Setup Espanso (work profile only)
if [[ "$PROFILE" == "work" ]]; then
    print_step "Step 9: Setting up Espanso (work profile)"
    if command -v espanso &> /dev/null; then
        ESPANSO_CONFIG_DIR="$HOME/Library/Application Support/espanso"
        mkdir -p "$ESPANSO_CONFIG_DIR/match"

        # Symlink base config
        create_symlink "$DOTFILES_DIR/base/espanso/config/default.yml" "$ESPANSO_CONFIG_DIR/config/default.yml"
        create_symlink "$DOTFILES_DIR/base/espanso/match/base.yml" "$ESPANSO_CONFIG_DIR/match/base.yml"

        # Symlink work-specific matches
        create_symlink "$DOTFILES_DIR/profiles/work/espanso/match/work.yml" "$ESPANSO_CONFIG_DIR/match/work.yml"

        print_success "Espanso configuration symlinked"
        print_info "Run 'espanso start' to enable text expansion"
    else
        print_warning "Espanso not installed, skipping configuration"
    fi
fi

# Step 10: Setup VSCodium extensions
print_step "Step 10: Installing VSCodium extensions"
if command -v codium &> /dev/null; then
    if [ -f "$DOTFILES_DIR/config/vscodium-extensions.txt" ]; then
        print_info "Installing VSCodium extensions..."
        local failed_extensions=0
        local total_extensions=$(wc -l < "$DOTFILES_DIR/config/vscodium-extensions.txt")

        while IFS= read -r extension; do
            # Skip empty lines and comments
            [[ -z "$extension" || "$extension" =~ ^# ]] && continue

            if codium --install-extension "$extension" 2>&1 | grep -q "successfully installed\|already installed"; then
                print_success "Installed: $extension"
            else
                add_warning "Failed to install VSCodium extension: $extension"
                ((failed_extensions++))
            fi
        done < "$DOTFILES_DIR/config/vscodium-extensions.txt"

        if [ $failed_extensions -eq 0 ]; then
            print_success "All VSCodium extensions installed successfully"
        else
            print_warning "Installed $(( total_extensions - failed_extensions ))/$total_extensions extensions"
        fi
    fi

    # Symlink settings
    VSCODIUM_USER_DIR="$HOME/Library/Application Support/VSCodium/User"
    if [ -d "$VSCODIUM_USER_DIR" ]; then
        create_symlink "$DOTFILES_DIR/config/vscodium-settings.json" "$VSCODIUM_USER_DIR/settings.json"
    else
        add_warning "VSCodium User directory not found, settings not symlinked"
        print_info "Launch VSCodium once to create the directory, then re-run bootstrap"
    fi
else
    add_warning "VSCodium not found, skipping extensions"
fi

# Step 11: macOS defaults
print_step "Step 11: Configuring macOS defaults"
print_info "Setting macOS preferences..."

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Trackpad: enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

print_success "macOS defaults configured"

# Final steps
print_step "Installation Complete!"
print_success "Profile '$PROFILE' has been set up successfully!"

echo ""
echo "Next steps:"
echo "  1. Update your email in: $DOTFILES_DIR/profiles/$PROFILE/.gitconfig"
echo "  2. Configure AWS CLI (see: $DOTFILES_DIR/profiles/$PROFILE/AWS_CONFIG_README.md)"
if [[ "$PROFILE" == "personal" ]]; then
    echo "  3. Customize SSH hosts in: $DOTFILES_DIR/profiles/personal/ssh_config.additions"
    echo "  4. Review AeroSpace keybindings: $DOTFILES_DIR/aerospace-keybindings-reference.md"
else
    echo "  3. Customize work SSH hosts in: $DOTFILES_DIR/profiles/work/ssh_config.additions"
    echo "  4. Customize Espanso snippets in: $DOTFILES_DIR/profiles/work/espanso/match/work.yml"
    echo "  5. Review AeroSpace keybindings: $DOTFILES_DIR/aerospace-keybindings-reference.md"
fi
echo "  6. Restart your terminal or run: source ~/.zshrc"
echo "  7. Restart AeroSpace to apply window manager config"
echo ""

print_info "To switch profiles later, run: ./bootstrap.sh --profile [personal|work]"

# Print final summary of errors and warnings
echo ""
if ! print_summary; then
    exit 1
fi

trap - EXIT
