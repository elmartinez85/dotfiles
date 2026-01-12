#!/bin/bash

set -e  # Exit on error

echo "Installing Spaceship theme..."

# Check if Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Error: Oh My Zsh is not installed. Please install it first."
    exit 1
fi

# Set ZSH_CUSTOM if not set
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Clone Spaceship theme if not already installed
if [ -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
    echo "Spaceship theme is already installed."
else
    echo "Cloning Spaceship theme..."
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
fi

# Create symlink
if [ -L "$ZSH_CUSTOM/themes/spaceship.zsh-theme" ]; then
    echo "Spaceship theme symlink already exists."
else
    echo "Creating symlink..."
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi

echo "Spaceship theme installation complete!"
