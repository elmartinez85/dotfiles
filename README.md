# Dotfiles - Profile-Based macOS Setup

A comprehensive, profile-based collection of dotfiles and configuration for quickly setting up a new MacBook with either a **personal** or **work** environment.

## ✨ What's New: Profile System

This dotfiles repository now supports **two profiles**:
- 🏠 **Personal** - Full setup with personal tools (Discord, Cursor, Mullvad Browser, etc.)
- 💼 **Work** - Enterprise-friendly setup (Chrome, Firefox Dev, Espanso, no personal apps)

**Key benefits:**
- ✅ **90% shared configs** - Base configs are identical, only differences in profiles
- ✅ **Easy switching** - Run bootstrap with different profile flag
- ✅ **Separate credentials** - Different git emails, SSH hosts, AWS configs per profile
- ✅ **No duplication** - DRY principle applied to all configs

---

## 📋 Quick Start

### Prerequisites
- macOS (tested on macOS Sonoma+)
- Command Line Tools: `xcode-select --install`
- 1Password installed (for SSH key management)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/Documents/Repositories/dotfiles
cd ~/Documents/Repositories/dotfiles

# Run bootstrap with your chosen profile
./bootstrap.sh --profile personal  # For personal machine
# OR
./bootstrap.sh --profile work      # For work machine
```

### Post-Installation

1. **Update your Git email**: `vim profiles/{personal,work}/.gitconfig`
2. **Configure AWS CLI** (see `profiles/{personal,work}/AWS_CONFIG_README.md`)
3. **Restart terminal** or `source ~/.zshrc`
4. **Restart AeroSpace** to apply window manager config

---

## 📦 What's Included

### Shared Base (Both Profiles)
- **CLI Tools**: bat, eza, fd, fzf, ripgrep, starship, gh, jq, awscli
- **Applications**: 1Password, AeroSpace, VSCodium, Slack, Rectangle

### 🏠 Personal Profile Additions
- **Apps**: Cursor, Discord, Mullvad Browser, Obsidian, Calibre
- **AeroSpace**: `Alt+c` (Cursor), `Alt+d` (Discord), `Alt+o` (Obsidian)

### 💼 Work Profile Additions
- **Apps**: Firefox Developer Edition, Google Chrome, Espanso
- **AeroSpace**: `Alt+b` (Firefox Dev), `Alt+Shift+b` (Chrome)
- **Espanso**: Text expansion with work snippets

---

## 🏗️ Repository Structure

```
dotfiles/
├── base/                      # Shared configs (90%)
│   ├── Brewfile.base
│   ├── .zshrc, .zsh_aliases
│   ├── .gitconfig, starship.toml
│   └── aerospace-base.toml
│
├── profiles/
│   ├── personal/             # Personal additions
│   └── work/                 # Work additions
│
├── config/                   # Generated merged configs
├── scripts/                  # Helper scripts
├── bootstrap.sh              # Main installer
└── README.md
```

---

## ⌨️ AeroSpace Keybindings

- **Focus**: `Alt+h/j/k/l` (Vim-style)
- **Workspaces**: `Alt+1-9`, `Alt+Shift+1-9` (move)
- **Apps**: `Alt+b` (browser), `Alt+v` (VSCodium), `Alt+s` (Slack)
- **Service Mode**: `Alt+Shift+;` → `t` (tile all), `r` (reset), `f` (float)

Full reference: [aerospace-keybindings-reference.md](aerospace-keybindings-reference.md)

---

## 🔄 Switching Profiles

```bash
cd ~/Documents/Repositories/dotfiles
./bootstrap.sh --profile work     # Switch to work
./bootstrap.sh --profile personal # Switch to personal
```

---

## 🛠️ Customization

### Add Apps
```bash
echo 'cask "your-app"' >> profiles/personal/Brewfile.additions
```

### Add Espanso Snippets (Work)
Edit `profiles/work/espanso/match/work.yml`

### Add AeroSpace Shortcuts
Edit `profiles/{personal,work}/aerospace-apps.toml`

---

## 🔒 Security

- AWS credentials, SSH keys, API tokens are **NOT committed**
- Use 1Password SSH agent for key management
- Profile-specific git emails via `[include]`

---

## 📚 Resources

- [AeroSpace Docs](https://github.com/nikitabobko/AeroSpace)
- [Starship Config](https://starship.rs/config/)
- [Espanso Docs](https://espanso.org/docs/)

---

**Built with ❤️ for macOS productivity**
