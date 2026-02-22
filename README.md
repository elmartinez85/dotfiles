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
The bootstrap script automatically checks for these requirements:
- macOS 12.0 (Monterey) or higher
- Xcode Command Line Tools (script will offer to install if missing)
- Internet connection
- At least 5GB free disk space
- 1Password (optional, for SSH key management via SSH agent)

### Installation

```bash
# Clone the repository (can be anywhere, not just ~/Documents/Repositories/dotfiles)
git clone https://github.com/yourusername/dotfiles.git ~/path/to/dotfiles
cd ~/path/to/dotfiles

# Run bootstrap with your chosen profile
./bootstrap.sh --profile personal  # For personal machine
# OR
./bootstrap.sh --profile work      # For work machine
```

**Note**: The bootstrap script auto-detects its location, so you can clone the repository anywhere you like.

The script includes:
- **System requirements check** - Validates macOS version, Xcode CLT, disk space, and internet
- **Pre-flight validation** - Checks for all required files before making any system changes
- **Oh My Zsh installation** - Automatically installed if not present

If any requirements are missing, you'll get clear instructions on what's needed.

### Post-Installation

1. **Update your Git email**: `vim profiles/{personal,work}/.gitconfig`
2. **Configure AWS CLI** (see `profiles/{personal,work}/AWS_CONFIG_README.md`)
3. **Restart terminal** or `source ~/.zshrc`
4. **Restart AeroSpace** to apply window manager config

---

## 📦 What's Included

### Shared Base (Both Profiles)
- **CLI Tools**: bat, eza, fd, fzf, ripgrep, starship, gh, jq, awscli, tmux, neovim
- **Applications**: 1Password, AeroSpace, VSCodium, Slack, Rectangle, Alacritty
- **Shell**: Zsh with Oh My Zsh, custom functions for tmux, AWS, process management, and system info
- **Fonts**: JetBrains Mono Nerd Font (for icons in terminal/editor)

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
│   ├── .zshrc, .zsh_aliases, .zsh_functions
│   ├── .gitconfig, starship.toml
│   ├── .tmux.conf            # Tmux with vim bindings
│   ├── alacritty.toml        # Terminal emulator config
│   └── aerospace-base.toml
│
├── profiles/
│   ├── personal/             # Personal additions
│   └── work/                 # Work additions
│
├── config/                   # Generated merged configs
├── scripts/                  # Helper scripts
├── bootstrap.sh              # Main installer with update/reinstall modes
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

## 🧰 Helpful Shell Functions

The dotfiles include custom shell functions in `.zsh_functions`:

### Tmux Management
- `ts <name>` - Smart session manager (create or attach to tmux session)
- `tsl` - List all tmux sessions
- `tk <name>` - Kill tmux session by name
- `tka` - Kill all sessions except current

### Process Management
- `pk <name>` - Find and interactively kill processes by name
- `topmem [n]` - Show top N processes by memory usage (default 10)
- `topcpu [n]` - Show top N processes by CPU usage (default 10)

### System Information
- `sysinfo` - Comprehensive system info dashboard (OS, CPU, memory)
- `ports` - Show all listening TCP ports (requires sudo)
- `myports` - Show your listening TCP ports (no sudo needed)

### AWS Helpers
- `awsp [profile]` - Switch AWS profile with validation
- `awsc` - Clear AWS profile (use default)
- `whoami-aws` - Show current AWS identity
- `awsls` - List all AWS profiles with account info
- `s3ls` - Quick S3 bucket list

### Zsh Maintenance
- `zsh-fix-completions` - Remove broken completion symlinks

---

## 🔄 Update vs Reinstall Modes

When you run bootstrap on an already-installed profile, you'll be prompted to choose:

- **Update Mode** (fast ~30 seconds) - Only updates packages and refreshes configs
- **Reinstall Mode** (slow ~10 minutes) - Complete reinstall of everything

```bash
cd ~/Documents/Repositories/dotfiles
./bootstrap.sh --profile personal  # Will prompt: Update or Reinstall?
```

### Switching Profiles

```bash
./bootstrap.sh --profile work     # Switch to work
./bootstrap.sh --profile personal # Switch to personal
```

Note: Profile switching will install the new profile alongside the old one. Full profile cleanup is planned for a future update.

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
