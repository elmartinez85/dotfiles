#!/bin/bash

set -e  # Exit on error

echo "Installing Homebrew..."

# Check if Homebrew is already installed
if command -v brew &> /dev/null; then
    echo "Homebrew is already installed. Updating..."
    brew update
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo "Configuring Homebrew for Apple Silicon..."
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

echo "Homebrew installation complete!"
