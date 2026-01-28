# Migration Guide - Transitioning to Profile System

If you're currently using the old single-profile dotfiles setup, here's how to migrate to the new profile-based system.

## 🔄 Migration Steps

### Step 1: Backup Your Current Setup

```bash
cd ~/Documents/Repositories/dotfiles

# Backup your current symlinks
ls -la ~ | grep " -> " | grep dotfiles > ~/dotfiles_symlinks_backup.txt

# Backup current configs (just in case)
cp ~/.zshrc ~/.zshrc.backup
cp ~/.gitconfig ~/.gitconfig.backup
cp ~/.aerospace.toml ~/.aerospace.toml.backup
```

### Step 2: Pull Latest Changes

```bash
git fetch origin
git pull origin main
```

### Step 3: Choose Your Profile

Decide which profile fits your current machine:
- **Personal** - If this is your personal machine with Discord, Cursor, etc.
- **Work** - If this is a work machine

### Step 4: Run Bootstrap with Profile

```bash
# For personal machine
./bootstrap.sh --profile personal

# For work machine
./bootstrap.sh --profile work
```

The bootstrap script will:
- ✅ Remove old symlinks
- ✅ Create new profile-aware symlinks
- ✅ Install profile-specific apps
- ✅ Merge configs (base + profile)

### Step 5: Update Profile-Specific Settings

```bash
# Update your git email
vim profiles/personal/.gitconfig  # or profiles/work/.gitconfig

# Customize SSH hosts
vim profiles/personal/ssh_config.additions  # or work

# (Work only) Customize Espanso snippets
vim profiles/work/espanso/match/work.yml
```

### Step 6: Reload Configs

```bash
# Reload shell
source ~/.zshrc

# Reload AeroSpace (new keybindings!)
aerospace reload-config
# or restart AeroSpace app
```

### Step 7: Test AeroSpace Keybindings

**Old keybindings (Hyper key) are gone!**

New keybindings use simple `Alt`:
- `Alt+h/j/k/l` - Focus windows
- `Alt+1-9` - Switch workspaces
- `Alt+Shift+;` - Service mode

See [aerospace-keybindings-reference.md](aerospace-keybindings-reference.md) for full list.

### Step 8: Optional - Uninstall Karabiner

If you were using Karabiner-Elements for the Hyper key, you can now uninstall it:

```bash
# See KARABINER_UNINSTALL.md for full instructions
brew uninstall --zap --cask karabiner-elements
```

---

## ⚠️ Breaking Changes

### 1. AeroSpace Keybindings Changed

| Old (Hyper key) | New (Alt) |
|-----------------|-----------|
| `Caps Lock + h` | `Alt + h` |
| `Caps Lock + 1` | `Alt + 1` |
| `Caps Lock + t` | `Alt + Shift + ;` then `t` |
| `Caps Lock + Shift + 1` | `Alt + Shift + 1` |

### 2. Bootstrap Now Requires Profile

Old:
```bash
./bootstrap.sh
```

New:
```bash
./bootstrap.sh --profile personal
# or
./bootstrap.sh --profile work
```

### 3. Config Files Moved

| Old Location | New Location |
|--------------|--------------|
| `config/.zshrc` | `base/.zshrc` |
| `config/.gitconfig` | `base/.gitconfig` + `profiles/{personal,work}/.gitconfig` |
| `config/aerospace.toml` | `base/aerospace-base.toml` + `profiles/{personal,work}/aerospace-apps.toml` |

---

## 🐛 Troubleshooting

### Issue: Keybindings Not Working

**Solution:**
1. Reload AeroSpace config: `Alt+Shift+;` then `Esc`
2. Or restart AeroSpace app
3. Check System Settings > Privacy & Security > Accessibility
4. Make sure AeroSpace has permission

### Issue: Git Email Still Wrong

**Solution:**
1. Check active profile: `cat ~/Documents/Repositories/dotfiles/.profile_active`
2. Edit profile git config: `vim profiles/personal/.gitconfig`
3. Verify: `git config user.email`

### Issue: Apps Not Launching with Alt+Letter

**Solution:**
1. Check if app is installed: `ls /Applications/`
2. Verify app path in `profiles/{personal,work}/aerospace-apps.toml`
3. Reload AeroSpace config

### Issue: Old Hyper Key Still Active

**Solution:**
1. Check if Karabiner is still running: `ps aux | grep karabiner`
2. Quit Karabiner: `pkill -9 karabiner`
3. Uninstall if not needed (see [KARABINER_UNINSTALL.md](KARABINER_UNINSTALL.md))

### Issue: Espanso Not Working (Work Profile)

**Solution:**
1. Check if installed: `which espanso`
2. Start espanso: `espanso start`
3. Check status: `espanso status`
4. View logs: `espanso log`

---

## ✅ Verification Checklist

After migration, verify everything works:

- [ ] Shell loads without errors: `source ~/.zshrc`
- [ ] Git config correct: `git config user.email`
- [ ] AeroSpace keybindings work: `Alt+h/j/k/l`
- [ ] App shortcuts work: `Alt+b` (browser), `Alt+v` (VSCodium)
- [ ] Service mode works: `Alt+Shift+;` then `t`
- [ ] Starship prompt loads correctly
- [ ] fzf works: `Ctrl+R` for history search
- [ ] SSH config correct: `ssh -T git@github.com`
- [ ] (Work) Espanso works: Type `:date` and press space

---

## 🆘 Rollback

If something goes wrong and you want to go back:

```bash
cd ~/Documents/Repositories/dotfiles

# Restore from backups
cp ~/.zshrc.backup ~/.zshrc
cp ~/.gitconfig.backup ~/.gitconfig
cp ~/.aerospace.toml.backup ~/.aerospace.toml

# Or checkout old commit
git log --oneline  # Find commit before profile system
git checkout <commit-hash>
./bootstrap.sh.backup  # Run old bootstrap
```

---

## 💬 Need Help?

- Check [PROFILE_SYSTEM_SUMMARY.md](PROFILE_SYSTEM_SUMMARY.md) for architecture overview
- Check [README.md](README.md) for usage instructions
- Check [aerospace-keybindings-reference.md](aerospace-keybindings-reference.md) for keybindings

---

**Happy migrating!** 🚀
