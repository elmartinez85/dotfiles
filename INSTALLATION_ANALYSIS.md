# Installation Process Analysis

This document provides a comprehensive analysis of the dotfiles installation process across three scenarios: fresh installation, reinstallation, and profile switching.

## Scenario 1: Fresh Installation on New Machine

### Prerequisites (ASSUMED - NOT DOCUMENTED)
1. ❌ **macOS version** - No minimum version specified
2. ❌ **Xcode Command Line Tools** - Required but not checked or auto-installed
3. ⚠️ **1Password** - Assumed to be pre-installed for SSH agent (mentioned in README prerequisites but not validated)
4. ❌ **Oh My Zsh** - CRITICAL: Required by `.zshrc` but NEVER installed by bootstrap!

### Installation Flow

#### Step 0: Pre-flight Validation ✅
**What it does:**
- Validates all required files exist in the dotfiles repo
- Checks base files, profile files, and directories

**Issues:**
- ✅ Good fail-fast approach
- ✅ Clear error messages

#### Step 1: Homebrew Installation ✅
**What it does:**
- Installs Homebrew if not present
- Adds to PATH for Apple Silicon
- Updates if already installed

**Issues:**
- ✅ Handles Apple Silicon vs Intel
- ⚠️ Modifies `~/.zprofile` directly - could conflict with existing content
- ⚠️ Doesn't check for write permissions

#### Step 2: Package Installation ⚠️
**What it does:**
- Merges `base/Brewfile.base` with profile's `Brewfile.additions`
- Creates temporary `Brewfile` in dotfiles directory
- Installs all packages via `brew bundle`

**Issues:**
- ✅ Proper tap paths for aerospace and borders
- ❌ **Generated `Brewfile` not in `.gitignore`** - will show as untracked file
- ⚠️ No error handling for individual package failures
- ⚠️ Long-running step with no progress indication
- ⚠️ Doesn't handle cask reinstall scenarios (if app already exists)

#### Step 3: Zsh Configuration ⚠️
**What it does:**
- Symlinks `.zshrc`, `.zsh_aliases`, `.zsh_functions` to home directory
- Backs up existing files to `.backup`

**Issues:**
- ✅ Creates backups properly
- ❌ **CRITICAL: Oh My Zsh is NEVER installed!** `.zshrc` will fail on line 48: `source $ZSH/oh-my-zsh.sh`
- ⚠️ No validation that symlinks work
- ⚠️ If user has existing `.zshrc`, backup only happens once (no timestamp)

#### Step 4: Git Configuration ✅
**What it does:**
- Symlinks base `.gitconfig` and `.gitignore_global`
- Symlinks profile-specific `.gitconfig` to `.gitconfig.profile`
- Base `.gitconfig` uses `[include]` to load profile config

**Issues:**
- ✅ Clean separation of base and profile configs
- ⚠️ Warning about email is printed but easy to miss
- ⚠️ No validation that email was updated

#### Step 5: SSH Configuration ⚠️
**What it does:**
- Creates `~/.ssh` directory with proper permissions
- Generates new `~/.ssh/config` file (OVERWRITES existing!)
- Hardcodes 1Password SSH agent path
- Symlinks profile SSH additions

**Issues:**
- ❌ **DESTRUCTIVE: Completely overwrites existing SSH config!** No backup!
- ❌ Assumes 1Password is installed and configured
- ⚠️ No validation of 1Password agent socket path
- ⚠️ SSH config generation happens EVERY time (not idempotent)

#### Step 6: Starship Configuration ✅
**What it does:**
- Checks if starship is installed
- Symlinks configuration if available
- Skips with warning if not installed

**Issues:**
- ✅ Safe, graceful degradation
- ✅ Non-destructive

#### Step 7: AeroSpace Configuration ⚠️
**What it does:**
- Checks for AeroSpace.app in /Applications
- Merges base config with profile app shortcuts
- Generates `config/aerospace.toml`
- Symlinks to `~/.aerospace.toml`

**Issues:**
- ⚠️ **Generated `config/aerospace.toml` not in `.gitignore`** - will show as modified
- ⚠️ Complex sed manipulation - fragile if profile file format changes
- ⚠️ Checks for `/Applications/AeroSpace.app` but Homebrew installs to `/Applications/AeroSpace.app` anyway
- ⚠️ No validation of generated TOML syntax

#### Step 8: fzf Configuration ✅
**What it does:**
- Checks if fzf is installed
- Runs fzf installer if not already configured
- Idempotent check for `~/.fzf.zsh`

**Issues:**
- ✅ Properly idempotent
- ✅ Graceful degradation

#### Step 9: Espanso Configuration (Work Profile) ⚠️
**What it does:**
- Only runs for work profile
- Symlinks base and work-specific Espanso configs

**Issues:**
- ⚠️ Creates directories without checking permissions
- ⚠️ Doesn't start Espanso service automatically
- ⚠️ No validation that Espanso was actually installed

#### Step 10: VSCodium Configuration ⚠️
**What it does:**
- Installs extensions from `config/vscodium-extensions.txt`
- Symlinks settings.json
- Only if VSCodium user directory exists

**Issues:**
- ⚠️ Silent failures on extension installation (suppressed with 2>/dev/null)
- ⚠️ No validation that extensions installed successfully
- ⚠️ User directory might not exist yet if VSCodium never run
- ⚠️ Settings symlink might fail silently

#### Step 11: macOS Defaults ⚠️
**What it does:**
- Sets various macOS preferences
- No conditionals or checks

**Issues:**
- ⚠️ Applies to ALL macOS versions - no version checks
- ⚠️ No warning about Finder restart requirement
- ⚠️ Some settings require logout/restart to take effect (not mentioned)
- ⚠️ Destructive - changes system preferences without asking

### Missing Steps
1. ❌ **Oh My Zsh installation** - CRITICAL!
2. ❌ **Neovim configuration** - kickstart.nvim not mentioned or automated
3. ❌ **System requirements check** (Xcode CLT, macOS version)
4. ❌ **Internet connectivity check**
5. ❌ **Disk space check**
6. ❌ **Cleanup of generated files** (Brewfile, config/aerospace.toml)

---

## Scenario 2: Reinstalling Same Profile

### Expected Behavior
User runs: `./bootstrap.sh --profile personal` (when personal is already installed)

### What Actually Happens

#### Positive
- ✅ Pre-flight validation passes
- ✅ Homebrew update runs (good for package updates)
- ✅ Symlink function handles existing symlinks (removes and recreates)
- ✅ Brewfile merging works

#### Issues
1. ❌ **SSH config is OVERWRITTEN** - any manual changes lost!
2. ⚠️ **Backup files accumulate** - each file only backed up once (overwrites previous backup)
3. ⚠️ **brew bundle reinstalls everything** - slow and unnecessary
4. ⚠️ **VSCodium extensions reinstalled** - slow
5. ⚠️ **macOS defaults reapplied** - unnecessary
6. ⚠️ **No indication this is a reinstall** - looks identical to fresh install
7. ❌ **Generated files (Brewfile, aerospace.toml) overwritten** - if user edited them, changes lost

### What's Missing
1. ❌ No detection that profile is already installed
2. ❌ No option to skip already-configured steps
3. ❌ No preservation of user customizations
4. ❌ No update mode vs fresh install mode

### Recommendation
**Add a detection mechanism:**
```bash
if [ -f "$DOTFILES_DIR/.profile_active" ] && [ "$(cat "$DOTFILES_DIR/.profile_active")" == "$PROFILE" ]; then
    print_warning "Profile '$PROFILE' is already installed"
    read -p "Do you want to: [r]einstall, [u]pdate, or [c]ancel? " choice
    case "$choice" in
        u|U) UPDATE_MODE=true ;;
        r|R) REINSTALL_MODE=true ;;
        c|C) exit 0 ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac
fi
```

---

## Scenario 3: Profile Switching

### Expected Behavior
User runs: `./bootstrap.sh --profile work` (switching from personal)

### What Actually Happens

#### Positive
- ✅ `.profile_active` file updated to new profile
- ✅ Profile-specific Git config symlink updated
- ✅ Profile-specific SSH additions symlink updated
- ✅ AeroSpace config regenerated with new profile apps

#### Critical Issues

##### Issue 1: Brewfile Handling ❌
**Problem:**
- Personal profile apps remain installed
- Work profile apps get added
- Result: BOTH profiles' apps installed!

**Example:**
- Personal has: Discord, Cursor, Obsidian, Mullvad Browser
- Work has: Chrome, Firefox Dev, Espanso, Bruno
- After switch: ALL of them installed (wasted disk space, potential conflicts)

**What should happen:**
- Uninstall personal-only apps
- Install work-only apps
- Keep shared base apps

##### Issue 2: Espanso Configuration ⚠️
**Problem:**
- Work profile: Espanso configs symlinked
- Personal profile: Espanso configs remain (orphaned symlinks)
- No cleanup of personal profile's Espanso config

##### Issue 3: SSH Configuration ❌
**Problem:**
- SSH config COMPLETELY regenerated
- Profile include updated
- BUT: Old SSH config content (if manually edited) is LOST

##### Issue 4: AeroSpace Configuration ⚠️
**Problem:**
- Config regenerated for new profile
- Keybindings change (Alt+d for Discord vs Alt+b for Chrome)
- No warning about changed keybindings
- User muscle memory breaks

##### Issue 5: Zsh Configuration ✅
**Surprisingly OK:**
- Symlinks point to same base files
- DOTFILES variable resolves correctly
- Aliases and functions work

##### Issue 6: Git Configuration ⚠️
**Problem:**
- `.gitconfig.profile` updated to new profile
- Email address changes
- BUT: Git identity changes mid-work!
- Existing repositories might have wrong author

##### Issue 7: VSCodium Configuration ⚠️
**Problem:**
- Settings symlink points to same file (shared)
- Extensions reinstalled (unnecessary)
- No profile-specific settings support

### What's Missing from Profile Switching

1. ❌ **No cleanup of old profile's apps** - Brew packages accumulate
2. ❌ **No backup before switching** - can't rollback
3. ❌ **No comparison of what will change** - user is blind
4. ❌ **No warning about breaking changes** (SSH config, git identity)
5. ❌ **No confirmation prompt** - destructive operation with no safety
6. ❌ **No post-switch cleanup** script
7. ❌ **No rollback mechanism**

### Recommendation

**Add profile switching logic:**

```bash
if [ -f "$DOTFILES_DIR/.profile_active" ]; then
    OLD_PROFILE=$(cat "$DOTFILES_DIR/.profile_active")
    if [ "$OLD_PROFILE" != "$PROFILE" ]; then
        print_warning "Switching from $OLD_PROFILE to $PROFILE"
        print_warning "This will:"
        echo "  • Update Git identity (email address)"
        echo "  • Regenerate SSH configuration"
        echo "  • Change AeroSpace keybindings"
        echo "  • Install new profile applications"
        echo ""
        read -p "Continue? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi

        # Backup current config
        backup_dir="$DOTFILES_DIR/.backups/$(date +%Y%m%d-%H%M%S)-$OLD_PROFILE"
        mkdir -p "$backup_dir"
        cp -L ~/.ssh/config "$backup_dir/" 2>/dev/null || true
        cp -L ~/.gitconfig.profile "$backup_dir/" 2>/dev/null || true
        print_success "Backed up to: $backup_dir"
    fi
fi
```

---

## Critical Issues Summary

### 🔴 Blocker Issues (Will Cause Failure)

1. **Oh My Zsh Not Installed**
   - `.zshrc` will fail immediately on fresh install
   - User gets broken shell
   - **Fix:** Add Oh My Zsh installation step before Zsh config

2. **SSH Config Overwritten Without Backup**
   - User loses existing SSH configuration
   - No way to recover
   - **Fix:** Backup existing config or append instead of overwrite

### 🟡 Major Issues (Poor User Experience)

3. **Generated Files Not in .gitignore**
   - `Brewfile` and `config/aerospace.toml` show as modified
   - Confuses git status
   - **Fix:** Add to `.gitignore`

4. **No Profile Switch Detection**
   - Apps accumulate from both profiles
   - No cleanup mechanism
   - **Fix:** Detect profile switch and handle cleanup

5. **No Update vs Reinstall Mode**
   - Reinstalling is slow and destructive
   - No intelligence about what needs updating
   - **Fix:** Add update mode that only changes what's needed

6. **Silent Failures**
   - VSCodium extensions fail silently
   - Some commands use `2>/dev/null`
   - **Fix:** Proper error handling and logging

### 🟢 Minor Issues (Polish Needed)

7. **No System Requirements Check**
   - Assumes Xcode CLT installed
   - No macOS version check
   - **Fix:** Add preflight system checks

8. **No Neovim Setup Automation**
   - NEOVIM_SETUP.md exists but not integrated
   - Manual steps required
   - **Fix:** Optionally install kickstart.nvim

9. **macOS Defaults Applied Without Warning**
   - Changes system preferences silently
   - Some need restart to take effect
   - **Fix:** Make optional or add confirmation

10. **No Progress Indicators**
    - Long-running steps (brew bundle) appear frozen
    - **Fix:** Add progress feedback

---

## Assumptions & Undocumented Requirements

### Hard Assumptions
1. ❌ User has macOS (no Linux/Windows support check)
2. ❌ User has admin/sudo access (needed for some settings)
3. ❌ 1Password installed and configured
4. ❌ Internet connectivity
5. ❌ Xcode Command Line Tools installed
6. ❌ User wants Oh My Zsh (hardcoded in .zshrc)
7. ❌ User is okay with system preferences being changed
8. ❌ Repository cloned with git (not as zip)

### Soft Assumptions
1. ⚠️ User has enough disk space
2. ⚠️ User wants VSCodium (not VS Code)
3. ⚠️ User uses zsh as default shell
4. ⚠️ User wants all macOS defaults changed
5. ⚠️ Apple Silicon Mac (Intel works but less tested)

---

## Recommendations Priority

### P0 - Must Fix Before Next Use
1. **Install Oh My Zsh** - Add to bootstrap before Step 3
2. **Backup SSH config** - Don't overwrite without backup
3. **Add generated files to .gitignore** - Clean git status

### P1 - Critical for Production Use
4. **Profile switch detection** - Handle cleanup properly
5. **System requirements check** - Validate prerequisites
6. **Update mode** - Don't reinstall everything
7. **Error handling** - Don't hide failures

### P2 - Nice to Have
8. **Neovim automation** - Optional kickstart.nvim install
9. **Progress indicators** - Better UX
10. **macOS defaults optional** - Ask before changing
11. **Rollback mechanism** - Safety net

---

## Testing Recommendations

### Before Declaring Production-Ready

1. **Test on truly fresh Mac**
   - Factory reset or VM
   - No Xcode CLT
   - No Homebrew
   - No 1Password

2. **Test profile switching**
   - Personal → Work
   - Work → Personal
   - Same profile reinstall

3. **Test error conditions**
   - No internet
   - Disk full
   - Permission denied
   - Interrupted installation

4. **Test with existing configs**
   - User already has .zshrc
   - User already has SSH config
   - User already has Homebrew

---

## Conclusion

The dotfiles setup is **well-structured** and **mostly functional**, but has several **critical gaps** that will cause failures on fresh installations:

1. **Oh My Zsh missing** = broken shell
2. **SSH config overwrite** = lost configuration
3. **No profile switch handling** = accumulating apps

The installation process needs:
- Better **error handling**
- More **idempotency**
- Smarter **profile switching**
- Proper **prerequisites checking**

**Current State:** 70% complete, works for maintainer, breaks for fresh users

**Recommended State:** Add P0 fixes immediately, P1 before sharing publicly
