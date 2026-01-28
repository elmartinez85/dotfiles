# AeroSpace Keybindings Reference

## 🔑 Modifier Key
All AeroSpace commands use **Alt** as the base modifier (or **Alt + Shift** for move operations).
- Simple and conflict-free
- Works everywhere - no special software required
- Example: `Alt + h` moves focus left

---

## 🎯 Essential Commands (Most-Used)

### Window Focus (Vim-style)
- **Alt + h** → Focus left
- **Alt + j** → Focus down
- **Alt + k** → Focus up
- **Alt + l** → Focus right

### Workspace Switching
- **Alt + 1-9** → Switch to workspace 1-9
- **Alt + Tab** → Toggle between last two workspaces

### Move Windows
- **Alt + Shift + h/j/k/l** → Move window in direction
- **Alt + Shift + arrows** → Move window with arrow keys
- **Alt + Shift + 1-9** → Move window to workspace 1-9

### Layout Arrangements
- **Alt + e** → Auto tiles (balanced grid)
- **Alt + ,** → Accordion layout (stacked/side-by-side)
- **Alt + f** → Fullscreen toggle

### Resize
- **Alt + Shift + -** → Shrink window
- **Alt + Shift + =** → Grow window

---

## 🚀 App Launcher Shortcuts

Launch apps instantly with **Alt + letter**:

### Browsers
- **Alt + b** → Mullvad Browser
- **Alt + Shift + b** → Safari

### Code Editors
- **Alt + c** → Cursor
- **Alt + v** → VSCodium

### Terminal
- **Alt + t** → Terminal

### Communication
- **Alt + s** → Slack
- **Alt + d** → Discord

### Note-Taking
- **Alt + o** → Obsidian

### Utilities
- **Alt + p** → 1Password

---

## 🔧 Service Mode (Advanced Operations)

**Enter Service Mode**: **Alt + Shift + ;** (semicolon)

Once in service mode, press:

### Layout Operations
- **r** → Reset layout (flatten workspace tree)
- **f** → Toggle floating/tiling mode
- **t** → Force all windows to tile (fix overlaps!)
- **b** → Balance all window sizes

### Window Management
- **Backspace** → Close all windows except current
- **Esc** → Reload config & exit service mode

### Join Windows (Advanced)
Combine windows into the same container:
- **Alt + Shift + h** → Join with left
- **Alt + Shift + j** → Join with down
- **Alt + Shift + k** → Join with up
- **Alt + Shift + l** → Join with right

---

## 🗂️ Workspace Auto-Assignments

Apps automatically go to their designated workspaces:

- **Workspace 1**: Browsers (Mullvad, Safari)
- **Workspace 2**: Code Editors (Cursor, VSCodium)
- **Workspace 3**: (Available - Terminal optional)
- **Workspace 4**: Notes (Obsidian)
- **Workspace 5**: Communication (Slack, Discord)
- **Workspace 6-9**: (Available for your custom assignments)

---

## 💡 Common Workflows

### Scenario 1: "I have overlapping windows!"
1. **Alt + Shift + ;** → Enter service mode
2. **t** → Tile all windows (automatically exits service mode)
3. **Alt + e** → Arrange in balanced grid (if needed)

### Scenario 2: "Navigate between windows fast"
1. **Alt + h/j/k/l** → Vim-style navigation
2. No mouse needed!

### Scenario 3: "Open app and switch to it"
1. **Alt + c** → Open Cursor (automatically goes to workspace 2)
2. **Alt + 2** → Switch to workspace 2 (if not already there)

### Scenario 4: "Organize across workspaces"
1. **Alt + 1** → Go to workspace 1
2. **Alt + b** → Open browser
3. **Alt + 2** → Go to workspace 2
4. **Alt + c** → Open code editor
5. **Alt + Shift + 3** → Move current window to workspace 3 (if needed)

### Scenario 5: "Clean up workspace fast"
1. Focus the window you want to keep
2. **Alt + Shift + ;** → Enter service mode
3. **Backspace** → Close all other windows

### Scenario 6: "Balance window sizes"
1. **Alt + Shift + ;** → Enter service mode
2. **b** → Balance all windows equally

---

## 🚀 Pro Tips

1. **Alt is your window manager key** - all AeroSpace commands use it
2. **App launchers are fast** - `Alt + letter` is quicker than Spotlight
3. **Service mode for advanced stuff** - Keeps main keybindings simple
4. **Auto-assignments save time** - Apps go to the right workspace automatically
5. **Alt + Tab for quick switching** - Toggle between last two workspaces
6. **No conflicts with most apps** - Alt combos are rarely used by applications
7. **Works everywhere** - Same keybindings at home and work

---

## 🔧 Troubleshooting

**Keybindings not working?**
1. **Alt + Shift + ;** then **Esc** to reload config
2. Restart AeroSpace app if needed
3. Check System Settings > Privacy & Security > Accessibility
4. AeroSpace should be allowed

**App shortcuts not working?**
- Verify app is installed in `/Applications/`
- Check app name matches exactly (case-sensitive)
- Edit `~/.aerospace.toml` to fix app paths

**Wrong app bundle ID for auto-assignments?**
Find the correct bundle ID:
```bash
osascript -e 'id of app "AppName"'
```
Or list all windows with bundle IDs:
```bash
aerospace list-windows --all
```

**Some keys conflict with other apps?**
- Check if the app is using Alt shortcuts
- Edit `~/.aerospace.toml` to change conflicting keybindings
- Consider using different app launcher letters

---

## 📝 Configuration Files

- **AeroSpace config**: `~/Documents/Repositories/dotfiles/config/aerospace.toml`
- **Tile-all script**: `~/Documents/Repositories/dotfiles/scripts/aerospace-tile-all.sh`

---

## 🎓 Quick Reference Card

```
FOCUS:       Alt + h/j/k/l
MOVE:        Alt + Shift + h/j/k/l
WORKSPACE:   Alt + 1-9
MOVE TO WS:  Alt + Shift + 1-9
LAYOUT:      Alt + e/,/f
APPS:        Alt + b/c/v/t/s/d/o/p
SERVICE:     Alt + Shift + ;
  └─ tile:   t
  └─ reset:  r
  └─ float:  f
  └─ balance: b
  └─ close others: Backspace
```

Enjoy your powerful, streamlined window management! 🎉
