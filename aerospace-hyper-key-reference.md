# AeroSpace Hyper Key Reference

## What is the Hyper Key?
Your **Caps Lock** key now acts as a Hyper modifier (Cmd+Alt+Ctrl+Shift all at once).
- **Caps Lock + key** = Hyper key combo (conflict-free!)
- **Caps Lock alone** = Escape key (bonus feature)

---

## 🎯 Essential Commands (Your Most-Used)

### Fix Overlapping Windows (YOUR MAIN SOLUTION!)
- **Caps Lock + t** → Tile all floating/overlapping windows

### Window Focus (Vim-style)
- **Caps Lock + h** → Focus left
- **Caps Lock + j** → Focus down
- **Caps Lock + k** → Focus up
- **Caps Lock + l** → Focus right

### Workspace Switching
- **Caps Lock + 1-9** → Switch to workspace 1-9

### Layout Arrangements
- **Caps Lock + s** → Vertical layout (windows stacked)
- **Caps Lock + w** → Horizontal layout (side-by-side)
- **Caps Lock + e** → Auto tiles (balanced grid)

---

## 🔧 Window Management

### Move Windows
- **Caps Lock + ←** → Move window left
- **Caps Lock + →** → Move window right
- **Caps Lock + ↑** → Move window up
- **Caps Lock + ↓** → Move window down

### Move Window to Different Workspace
- **Caps Lock + a** → Move to workspace 1
- **Caps Lock + z** → Move to workspace 2
- **Caps Lock + x** → Move to workspace 3
- **Caps Lock + v** → Move to workspace 4
- **Caps Lock + n** → Move to workspace 5
- **Caps Lock + m** → Move to workspace 6
- **Caps Lock + ,** → Move to workspace 7
- **Caps Lock + .** → Move to workspace 8
- **Caps Lock + /** → Move to workspace 9

---

## 🎨 Layout & Display

### Window States
- **Caps Lock + f** → Fullscreen toggle
- **Caps Lock + Space** → Toggle floating/tiling mode

### Organization
- **Caps Lock + b** → Balance window sizes (make all equal)
- **Caps Lock + r** → Enter resize mode (then use h/j/k/l)

---

## 🛠️ System Commands

- **Caps Lock + c** → Reload AeroSpace config
- **Caps Lock + q** → Close focused window

### Move Workspace Between Monitors
- **Caps Lock + ;** → Move workspace to previous monitor
- **Caps Lock + '** → Move workspace to next monitor

---

## 🔄 Advanced (Optional)

### Join Windows (Advanced Container Management)
These still use **Alt+Ctrl** (kept for advanced users):
- **Alt + Ctrl + h** → Join with left container
- **Alt + Ctrl + j** → Join with down container
- **Alt + Ctrl + k** → Join with up container
- **Alt + Ctrl + l** → Join with right container

### Resize Mode
1. **Caps Lock + r** → Enter resize mode
2. Then use:
   - **h** → Decrease width
   - **j** → Increase height
   - **k** → Decrease height
   - **l** → Increase width
3. **Enter** or **Esc** → Exit resize mode

---

## 💡 Common Workflows

### Scenario 1: "I have 5 overlapping windows!"
1. **Caps Lock + t** → Tile all windows
2. **Caps Lock + s** → Arrange vertically
   OR **Caps Lock + w** → Arrange horizontally
   OR **Caps Lock + e** → Auto grid
3. **Caps Lock + b** → Balance sizes if needed

### Scenario 2: "Navigate between windows"
1. **Caps Lock + h/j/k/l** → Vim-style navigation
2. No more reaching for mouse!

### Scenario 3: "Organize across workspaces"
1. **Caps Lock + 1** → Go to workspace 1
2. Open apps, arrange windows
3. **Caps Lock + 2** → Go to workspace 2
4. **Caps Lock + a** → Move current window to workspace 1

### Scenario 4: "I'm stuck in fullscreen VSCodium!"
1. **Caps Lock + f** → Exit fullscreen
2. **Caps Lock + 1** → Now workspace switching works

---

## 🚀 Pro Tips

1. **Caps Lock is now your window manager key** - all AeroSpace commands start with it
2. **No more conflicts** - Apps can't steal these key combos
3. **Muscle memory**: Think "Caps Lock + action" for all window management
4. **Caps Lock alone** = Escape (useful for Vim users or closing dialogs)
5. **Keep your hands on home row** - Caps Lock is right there!

---

## 🔧 Troubleshooting

**Caps Lock still toggles caps?**
- Make sure Karabiner-Elements is running
- Check System Settings > Privacy & Security > Input Monitoring
- Karabiner should be allowed

**Keybindings not working?**
- **Caps Lock + c** to reload AeroSpace config
- Restart Karabiner-Elements app if needed

**Want caps lock back?**
- Press **Shift** to type capitals (or remap in Karabiner)

---

## 📝 Files Configured

- **Karabiner config**: `~/.config/karabiner/karabiner.json`
- **AeroSpace config**: `~/Documents/Repositories/dotfiles/config/aerospace.toml`
- **Tile-all script**: `~/Documents/Repositories/dotfiles/scripts/aerospace-tile-all.sh`

Enjoy your conflict-free, powerful window management! 🎉
