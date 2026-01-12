#!/bin/bash

set -e  # Exit on error

# Configure macOS settings
# Usage: bash scripts/configure_macos.sh

echo "Configuring macOS settings..."
echo ""

# Finder Settings
echo "Configuring Finder..."
# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
echo "✓ Hidden files and file extensions enabled"

# Screenshot Settings
echo ""
echo "Configuring Screenshots..."
# Create Screenshots directory if it doesn't exist
mkdir -p "$HOME/Documents/Screenshots"
# Set screenshot location
defaults write com.apple.screencapture location "$HOME/Documents/Screenshots"
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true
echo "✓ Screenshots will be saved to ~/Documents/Screenshots"

# Dock Settings
echo ""
echo "Configuring Dock..."
# Enable auto-hide
defaults write com.apple.dock autohide -bool true
# Set icon size to medium (48 pixels)
defaults write com.apple.dock tilesize -int 48
# Position Dock on the right
defaults write com.apple.dock orientation -string "right"
# Speed up animation
defaults write com.apple.dock autohide-time-modifier -float 0.5
# Remove delay for showing Dock
defaults write com.apple.dock autohide-delay -float 0
echo "✓ Dock configured: auto-hide enabled, medium size, right position"

# Trackpad Settings
echo ""
echo "Configuring Trackpad..."
# Disable natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
echo "✓ Natural scrolling disabled"

# Keyboard Settings
echo ""
echo "Configuring Keyboard..."
# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Set a faster key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
# Set a shorter delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15
echo "✓ Key repeat enabled and optimized"

# Restart affected applications
echo ""
echo "Restarting affected applications..."
killall Finder
killall Dock
killall SystemUIServer

echo ""
echo "========================================="
echo "macOS configuration complete!"
echo "========================================="
echo ""
echo "Changes applied:"
echo "  • Hidden files and file extensions visible in Finder"
echo "  • Screenshots save to ~/Documents/Screenshots"
echo "  • Dock: auto-hide, medium size, right position"
echo "  • Natural scrolling disabled"
echo "  • Faster key repeat enabled"
echo ""
