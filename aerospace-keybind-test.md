# AeroSpace Keybinding Test Checklist

## Setup Instructions

1. **Open 3-5 test windows** (Safari, Terminal, Finder, etc.)
2. **Make sure they're overlapping/floating** to simulate your original problem
3. **Keep this checklist visible** on a second monitor or workspace
4. Go through each test below and mark whether it works ✅ or fails ❌

## Pre-Test: Reload Config

- [ ] **Alt+Shift+c** - Reload AeroSpace config
  - Expected: You should see a brief notification or no error
  - Result: \***\*\_\_\*\***

---

## Section 1: Window Focus (Vim Navigation)

**Test with tiled windows side-by-side**

- [❌ ] **Alt+h** - Focus window to the left
  - Expected: Focus moves to left window
  - Actual behavior: Nothing happens

- [✅] **Alt+j** - Focus window below
  - Expected: Focus moves to window below
  - Actual behavior: Working as expected however sometimes can conflict and do nothing if you are focused in an application like VSCodium\_

- [✅] **Alt+k** - Focus window above
  - Expected: Focus moves to window above
  - Actual behavior: Works as expected

- [❌] **Alt+l** - Focus window to the right
  - Expected: Focus moves to right window
  - Actual behavior: Not working however I believe it's because the windows might be arraigned vertically on Workspace 1 but I am not sure how thckec this.

**Issue?** If these don't work, macOS or an app might be stealing Alt+h/j/k/l

---

## Section 2: Window Movement

**Test by moving a focused window around**

- [❌ ] **Alt+Shift+h** - Move window left
  - Expected: Window physically moves to the left position
  - Actual behavior: \***\*\_\_\*\***

- [❌ ] **Alt+Shift+j** - Move window down
  - Expected: Window moves down in the layout
  - Actual behavior: \***\*\_\_\*\***

- [❌ ] **Alt+Shift+k** - Move window up
  - Expected: Window moves up in the layout
  - Actual behavior: Nothing happens

- [❌ ] **Alt+Shift+l** - Move window right
  - Expected: Window moves to the right position
  - Actual behavior: Nothing happens

  --

## Section 3: Layout Management (THE IMPORTANT ONES!)

**Start with 5 overlapping/messy windows**

- [ ❌] **Alt+Shift+t** - Flatten workspace tree (NEW - your main fix!)
  - Expected: All overlapping windows snap into a tiled grid
  - Actual behavior: Does not work
  - **THIS IS THE KEY ONE FOR YOUR PROBLEM!**

- [❌ ] **Alt+t** - Reset to tiles layout (NEW)
  - Expected: Windows arrange into tiling layout
  - Actual behavior: Nothing happens

- [❌] **Alt+s** - Vertical accordion layout
  - Expected: Windows stack vertically (one above another)
  - Actual behavior: Nothing happens

- [❌] **Alt+w** - Horizontal accordion layout
  - Expected: Windows arrange horizontally (side by side)
  - Actual behavior: Nothing happens

- [❌] **Alt+e** - Default tiling
  - Expected: Windows auto-arrange in a balanced grid
  - Actual behavior: Nothing happens

- [❌] **Alt+Shift+space** - Toggle floating/tiling
  - Expected: Current window toggles between floating and tiled
  - Actual behavior: The window I am focused on goes fullscreen however no other windows on Workspace 1 move around they are all behind the window that just looks to have gone fullscreen

---

## Section 4: Join Commands (NEW - Advanced)

**Use when you want to manually organize windows**

- [❌ ] **Alt+Ctrl+h** - Join with window on left
  - Expected: Combines current window into left window's container
  - Actual behavior: Nothing happens

- [❌ ] **Alt+Ctrl+j** - Join with window below
  - Expected: Combines current window into below window's container
  - Actual behavior: Nothing happens

- [ ❌] **Alt+Ctrl+k** - Join with window above
  - Expected: Combines current window into above window's container
  - Actual behavior: Nothing happens

- [❌ ] **Alt+Ctrl+l** - Join with window on right
  - Expected: Combines current window into right window's container
  - Actual behavior: Nothing happens

---

## Section 5: Other Utilities

- [✅] **Alt+f** - Fullscreen
  - Expected: Window goes fullscreen
  - Actual behavior: \***\*\_\_\*\***

- [❌ ] **Alt+Shift+b** - Balance window sizes
  - Expected: All windows resize to equal sizes
  - Actual behavior: Does not do anything

- [✅] **Alt+Shift+q** - Close window
  - Expected: Focused window closes
  - Actual behavior: \***\*\_\_\*\***

---

## Section 6: Workspace Switching

- [✅] **Alt+1** through **Alt+9** - Switch to workspace 1-9
  - Expected: Switches to that workspace number
  - Actual behavior: \***\*\_\_\*\***

- [✅] **Alt+Shift+1** through **Alt+Shift+9** - Move window to workspace
  - Expected: Moves current window to that workspace
  - Actual behavior: \***\*\_\_\*\***

---

## Section 7: Resize Mode

- [✅] **Alt+r** - Enter resize mode
  - Expected: Enters resize mode (try h/j/k/l to resize)
  - Actual behavior: \***\*\_\_\*\***

**Once in resize mode:**

- [❌] **h** - Decrease width
- [❌ ] **j** - Increase height
- [❌ ] **k** - Decrease height
- [❌ ] **l** - Increase width
- [❌ ] **Enter or Esc** - Exit resize mode
- Actual behavior: On Workspace 2 where I have VSCodium it enters Resize mode correct however none of the resize keys seem to do anything

---

## Common Issues & Solutions

### If Alt+h/j/k/l don't work for focus:

- Check if macOS "Hide" command is stealing Alt+h
- Check System Settings > Keyboard > Keyboard Shortcuts

### If Alt+s/w/e don't work for layouts:

- Some apps override these (especially browsers, VS Code)
- Try when focused on Finder or Terminal first

### If Alt+Ctrl combinations don't work:

- Check if you have accessibility apps running
- Check System Settings > Privacy & Security > Accessibility

### If Alt+Shift+t doesn't flatten windows:

- Make sure windows are on the same workspace
- Try Alt+Shift+space first to toggle them out of floating mode

---

## Your Test Results Summary

## **Keybindings that DON'T work:**

-
- **Keybindings that work perfectly:**

-
- **Notes/observations:**

-
- ***

## Next Steps

Once you complete this checklist:

1. Share which keybindings failed
2. I'll help you either:
   - Find what's conflicting and disable it
   - Remap AeroSpace to use different keys
   - Switch to using Cmd instead of Alt as the modifier

**For your original problem (5 overlapping windows):**

- The main keybinding to test is **Alt+Shift+t** (flatten workspace tree)
- This should be your "panic button" when windows are messy
