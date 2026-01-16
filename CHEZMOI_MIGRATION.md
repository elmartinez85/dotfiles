# Chezmoi Migration Plan

This document outlines how to migrate your dotfiles from manual symlinks to Chezmoi management.

## Why Migrate to Chezmoi?

**Current Issues with Manual Symlinks:**
- No templating for machine-specific configs (work vs personal)
- Git credentials must be manually configured on each machine
- SSH config can't easily vary by machine
- Editor settings are the same everywhere
- Manual bootstrap script maintenance

**Benefits of Chezmoi:**
- ✅ **Templates**: Different configs per machine type
- ✅ **1Password Integration**: Pull secrets directly from 1Password
- ✅ **State Tracking**: Knows what's changed, only updates what's needed
- ✅ **Cross-Platform**: Same repo works on macOS/Linux
- ✅ **Built-in Scripts**: run_once, run_before, run_after hooks
- ✅ **Dry Run**: See what will change before applying
- ✅ **Diff Tool**: See differences before applying

## Migration Overview

### Phase 1: Current Structure
```
dotfiles/
├── config/
│   ├── .zshrc              → symlinked to ~/.zshrc
│   ├── .gitconfig          → copied to ~/.gitconfig
│   ├── ssh_config          → symlinked to ~/.ssh/config
│   └── vscodium-settings.json → symlinked
└── bootstrap.sh            → manual setup
```

### Phase 2: Chezmoi Structure
```
~/.local/share/chezmoi/        (your dotfiles repo)
├── .chezmoi.toml.tmpl         # Config with prompts
├── dot_zshrc.tmpl             # Template for ~/.zshrc
├── dot_gitconfig.tmpl         # Template with {{ .email }}
├── private_dot_ssh/
│   └── private_config.tmpl    # SSH config template
├── .chezmoiignore             # Files to skip
├── run_once_install-homebrew.sh
├── run_once_install-packages.sh
└── README.md
```

## Detailed Migration Steps

### Step 1: Initialize Chezmoi

```bash
# Chezmoi is already in your Brewfile
# Initialize in your dotfiles directory
cd ~/Documents/Repositories/dotfiles
chezmoi init

# This creates ~/.local/share/chezmoi linked to your repo
```

### Step 2: File Naming Convention

Chezmoi uses special prefixes:

| File in Chezmoi | Becomes | Attributes |
|---|---|---|
| `dot_zshrc` | `~/.zshrc` | Regular file |
| `dot_zshrc.tmpl` | `~/.zshrc` | Template (evaluated) |
| `private_dot_ssh` | `~/.ssh/` | Private (chmod 700) |
| `private_config.tmpl` | `config` | Private template |
| `executable_script.sh` | `script.sh` | Executable |
| `run_once_install.sh` | N/A | Runs once on apply |
| `run_before_*.sh` | N/A | Runs before apply |
| `run_after_*.sh` | N/A | Runs after apply |

### Step 3: Convert Files to Chezmoi Format

#### Example: .gitconfig Template

**Current:** `config/.gitconfig` (copied, manual name/email)

**New:** `dot_gitconfig.tmpl`
```toml
[user]
    name = {{ .name }}
    email = {{ .email }}

[init]
    defaultBranch = main

[core]
{{- if eq .machine "work" }}
    editor = code --wait
{{- else }}
    editor = codium --wait
{{- end }}
    autocrlf = input
    excludesfile = ~/.gitignore_global
# ... rest of config
```

#### Example: SSH Config Template

**Current:** `config/ssh_config` (symlinked)

**New:** `private_dot_ssh/private_config.tmpl`
```ssh-config
# SSH Configuration
Host *
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    ServerAliveInterval 60
    HostKeyAlgorithms ssh-ed25519,rsa-sha2-512,rsa-sha2-256

Host github.com
    HostName github.com
    User git
{{- if eq .machine "work" }}
    IdentityFile ~/.ssh/id_ed25519_work
{{- else }}
    IdentityFile ~/.ssh/id_ed25519_personal
{{- end }}

# ... rest of config
```

#### Example: .zshrc Template

**Current:** `config/.zshrc` (symlinked)

**New:** `dot_zshrc.tmpl`
```bash
# Shell history configuration
HISTSIZE=50000
SAVEHIST=50000
# ...

{{- if eq .machine "work" }}
# Work-specific settings
export COMPANY_ENV="production"
{{- else }}
# Personal machine settings
export DEV_MODE="true"
{{- end }}

# Rest of your .zshrc content...
```

### Step 4: Convert Bootstrap to Chezmoi Scripts

**Current:** `bootstrap.sh` (monolithic)

**New:** Multiple run_once scripts

#### `run_once_before_install-homebrew.sh.tmpl`
```bash
#!/bin/bash
# Install Homebrew (runs before applying dotfiles)

if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi
```

#### `run_once_install-packages.sh`
```bash
#!/bin/bash
# Install Homebrew packages

brew bundle --file={{ .chezmoi.sourceDir }}/Brewfile
```

#### `run_once_install-ohmyzsh.sh`
```bash
#!/bin/bash
# Install Oh My Zsh

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
```

### Step 5: 1Password Integration

Store secrets in 1Password, reference in templates:

**Example:** Store GitHub token in 1Password

```bash
# In your template files:
{{ (onepasswordItemFields "GitHub CLI Token").token.value }}
```

**Example:** SSH key from 1Password

```bash
# Generate SSH key and store in 1Password
# Reference in ssh config template
```

### Step 6: .chezmoiignore

Tell Chezmoi what NOT to manage:

```
# .chezmoiignore
README.md
LICENSE
.git/
scripts/
Brewfile
CHEZMOI_MIGRATION.md
bootstrap.sh  # Keep for reference
.claude/
```

### Step 7: Common Chezmoi Commands

```bash
# See what would change (dry run)
chezmoi diff

# Apply dotfiles (runs scripts too)
chezmoi apply

# Edit a file
chezmoi edit ~/.zshrc

# Update from repo
chezmoi update

# Add a new file to chezmoi
chezmoi add ~/.config/newfile

# See what chezmoi manages
chezmoi managed

# Re-run all run_once scripts
chezmoi state delete-bucket --bucket=entryState

# Verify everything
chezmoi verify
```

## Migration Workflow

### Option A: Clean Migration (Recommended)

1. **Backup current setup**
   ```bash
   cd ~/Documents/Repositories/dotfiles
   git checkout -b chezmoi-migration
   ```

2. **Initialize Chezmoi**
   ```bash
   chezmoi init ~/Documents/Repositories/dotfiles
   ```

3. **Convert files** (I can help with this)
   - Rename files with chezmoi conventions
   - Add templates where needed
   - Create run_once scripts from bootstrap.sh

4. **Test on a fresh machine or VM**
   ```bash
   chezmoi init --apply https://github.com/elmartinez85/dotfiles.git
   ```

5. **Merge to main when working**

### Option B: Gradual Migration

1. Keep current symlink system
2. Add chezmoi alongside (different branch)
3. Test chezmoi thoroughly
4. Switch when confident

## Comparison: Before & After

### Before (Manual)
```bash
# On new machine:
git clone https://github.com/elmartinez85/dotfiles.git
cd dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
# Enter name and email manually
# Wait for everything to install
source ~/.zshrc
```

### After (Chezmoi)
```bash
# On new machine:
brew install chezmoi
chezmoi init --apply https://github.com/elmartinez85/dotfiles.git
# Answer prompts (name, email, machine type)
# Everything installs automatically
# Done!
```

## Key Advantages

1. **Machine-Specific Configs**
   - Work laptop: Different git email, different SSH keys
   - Personal: Personal email, personal SSH keys
   - One repo, different outputs

2. **Secret Management**
   - Pull from 1Password on the fly
   - No secrets in git repo
   - `{{ onepasswordRead "op://Private/GitHub/token" }}`

3. **State Tracking**
   - Chezmoi knows what's applied
   - Only updates what changed
   - Can see diffs before applying

4. **Simplified Bootstrap**
   - No giant bootstrap.sh script
   - Scripts run in order automatically
   - Idempotent by default

## Migration Assistance

I can help you:
1. Convert all your current files to Chezmoi format
2. Create templates for machine-specific configs
3. Break down bootstrap.sh into run_once scripts
4. Set up 1Password integration
5. Test the migration

## Next Steps

Would you like me to:
1. ✅ Create all the Chezmoi-formatted files
2. ✅ Convert your current configs to templates
3. ✅ Break bootstrap.sh into run_once scripts
4. ✅ Set up the complete Chezmoi structure

Or would you prefer to:
- Try it manually first with this guide
- Ask questions about specific parts
- See a demo of how it works
