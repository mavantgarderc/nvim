# Neovim Navigation Cheatsheet

Designed to be **AuDHD-friendly** with clear, concise categories, short descriptions, and visual grouping for quick reference. Focuses on keybindings from your `navigations.lua` for managing buffers, panes, tabs, folds, and marks in Neovim.

---

## 🖥️ Terminal Multiplexer Navigation

Navigate between panes in tmux/zellij or Neovim windows if no multiplexer is detected.

| Keybinding | Action                             |
| ---------- | ---------------------------------- |
| `Alt+h`    | Move left (tmux/zellij or window)  |
| `Alt+j`    | Move down (tmux/zellij or window)  |
| `Alt+k`    | Move up (tmux/zellij or window)    |
| `Alt+l`    | Move right (tmux/zellij or window) |

---

## 📑 Buffer Management

Work with open files (buffers) in Neovim.

| Keybinding   | Action                          |
| ------------ | ------------------------------- |
| `<leader>bb` | Show current buffer's file path |
| `<leader>bl` | List all open buffers           |
| `<leader>bn` | Go to next buffer               |
| `<leader>bp` | Go to previous buffer           |
| `<leader>bd` | Delete current buffer           |

---

## 🪟 Pane Management

Manage split windows (panes) in Neovim.

### Switch Panes

| Keybinding   | Action                      |
| ------------ | --------------------------- |
| `<leader>;h` | Switch to left pane         |
| `<leader>;l` | Switch to right pane        |
| `<leader>;j` | Switch to bottom pane       |
| `<leader>;k` | Switch to top pane          |
| `<leader>hh` | Switch to left pane (alt)   |
| `<leader>ll` | Switch to right pane (alt)  |
| `<leader>jj` | Switch to bottom pane (alt) |
| `<leader>kk` | Switch to top pane (alt)    |

### Move Panes

| Keybinding   | Action              |
| ------------ | ------------------- |
| `<leader>HH` | Move pane to left   |
| `<leader>LL` | Move pane to right  |
| `<leader>JJ` | Move pane to bottom |
| `<leader>KK` | Move pane to top    |

### Split Panes

| Keybinding    | Action                  |
| ------------- | ----------------------- |
| `<leader>sph` | Split pane horizontally |
| `<leader>spv` | Split pane vertically   |

### Resize Panes

| Keybinding         | Action                  |
| ------------------ | ----------------------- |
| `Ctrl+Alt+h`       | Shrink pane width (-1)  |
| `Ctrl+Alt+l`       | Expand pane width (+1)  |
| `Ctrl+Alt+j`       | Shrink pane height (-1) |
| `Ctrl+Alt+k`       | Expand pane height (+1) |
| `Ctrl+Alt+Shift+H` | Shrink pane width (-5)  |
| `Ctrl+Alt+Shift+L` | Expand pane width (+5)  |
| `Ctrl+Alt+Shift+J` | Shrink pane height (-5) |
| `Ctrl+Alt+Shift+K` | Expand pane height (+5) |

### Other

| Keybinding  | Action               |
| ----------- | -------------------- |
| `<leader>T` | Move pane to new tab |

---

## 📑 Tab Management

Manage multiple tabs in Neovim.

### Tab Operations

| Keybinding   | Action                         |
| ------------ | ------------------------------ |
| `<leader>tn` | Create new tab                 |
| `<leader>tc` | Close current tab              |
| `<leader>to` | Close all other tabs           |
| `<leader>tt` | Go to next tab                 |
| `<leader>tp` | Go to previous tab             |
| `<leader>te` | Edit file in new tab (prompt)  |
| `<leader>tf` | Find file to open in new tab   |
| `<leader>tT` | Open terminal in new tab       |
| `<leader>tb` | Open current buffer in new tab |
| `<leader>td` | Drop file in tab (prompt)      |
| `<leader>ti` | List all tabs                  |

### Tab Navigation

| Keybinding   | Action          |
| ------------ | --------------- |
| `<leader>g1` | Go to tab 1     |
| `<leader>g2` | Go to tab 2     |
| `<leader>g3` | Go to tab 3     |
| `<leader>g4` | Go to tab 4     |
| `<leader>g5` | Go to tab 5     |
| `<leader>g6` | Go to tab 6     |
| `<leader>g7` | Go to tab 7     |
| `<leader>g8` | Go to tab 8     |
| `<leader>g9` | Go to tab 9     |
| `<leader>g0` | Go to last tab  |
| `<leader>th` | Go to first tab |
| `<leader>tl` | Go to last tab  |

### Move Tabs

| Keybinding   | Action                         |
| ------------ | ------------------------------ |
| `<leader>tm` | Move tab (prompt for position) |
| `<leader>t<` | Move tab left                  |
| `<leader>t>` | Move tab right                 |

### Close Tabs

| Keybinding   | Action                  |
| ------------ | ----------------------- |
| `<leader>tO` | Close all other tabs    |
| `<leader>tR` | Close tabs to the right |
| `<leader>tL` | Close tabs to the left  |

---

## 📂 Folding

Manage code folding for better organization.

### Create/Delete Folds

| Keybinding    | Action                              |
| ------------- | ----------------------------------- |
| `<leader>zff` | Create fold (normal or visual mode) |
| `<leader>zd`  | Delete fold under cursor            |
| `<leader>zD`  | Delete all folds in current line    |
| `<leader>zE`  | Eliminate all folds                 |

### Open/Close Folds

| Keybinding | Action                        |
| ---------- | ----------------------------- |
| `zo`       | Open fold under cursor        |
| `zO`       | Open all folds under cursor   |
| `zc`       | Close fold under cursor       |
| `zC`       | Close all folds under cursor  |
| `za`       | Toggle fold under cursor      |
| `zA`       | Toggle all folds under cursor |

### Global Fold Operations

| Keybinding   | Action                           |
| ------------ | -------------------------------- |
| `<leader>z+` | Open one fold level (reduce)     |
| `<leader>z-` | Close one fold level (fold more) |
| `<leader>zR` | Open all folds                   |
| `<leader>zM` | Close all folds                  |

### Fold Navigation

| Keybinding | Action                        |
| ---------- | ----------------------------- |
| `zj`       | Move to next fold             |
| `zk`       | Move to previous fold         |
| `[z`       | Move to start of current fold |
| `]z`       | Move to end of current fold   |

### Fold View

| Keybinding | Action                            |
| ---------- | --------------------------------- |
| `zv`       | Open folds to view cursor line    |
| `zx`       | Update folds                      |
| `zX`       | Undo manually opened/closed folds |

### Fold Levels

| Keybinding | Action              |
| ---------- | ------------------- |
| `z1`       | Set fold level to 1 |
| `z2`       | Set fold level to 2 |
| `z3`       | Set fold level to 3 |
| `z4`       | Set fold level to 4 |
| `z5`       | Set fold level to 5 |
| `z6`       | Set fold level to 6 |
| `z7`       | Set fold level to 7 |
| `z8`       | Set fold level to 8 |
| `z9`       | Set fold level to 9 |
| `z0`       | Set fold level to 0 |

### Fold Methods

| Keybinding    | Action                    |
| ------------- | ------------------------- |
| `<leader>zmi` | Set fold method to indent |
| `<leader>zms` | Set fold method to syntax |
| `<leader>zmm` | Set fold method to manual |
| `<leader>zme` | Set fold method to expr   |
| `<leader>zmk` | Set fold method to marker |
| `<leader>zmd` | Set fold method to diff   |

### Other Fold Actions

| Keybinding    | Action                               |
| ------------- | ------------------------------------ |
| `<leader>zfc` | Toggle fold column visibility        |
| `<leader>zi`  | Show fold info (method, level, etc.) |
| `<leader>zt`  | Toggle folding on/off                |
| `<leader>zcc` | Fold all comments                    |
| `<leader>zs`  | Save fold state                      |
| `<leader>zl`  | Load fold state                      |

---

## 🔖 Marks

Mark and jump to specific locations in files.

### Set Marks

| Keybinding   | Action                |
| ------------ | --------------------- |
| `<leader>mm` | Set mark M (Main)     |
| `<leader>mt` | Set mark T (Top)      |
| `<leader>mb` | Set mark B (Bottom)   |
| `<leader>ms` | Set mark S (Section)  |
| `<leader>mf` | Set mark F (Function) |
| `<leader>m.` | Mark current position |
| `<leader>mr` | Mark for return       |

### Jump to Marks (Line)

| Keybinding   | Action                  |
| ------------ | ----------------------- |
| `<leader>jm` | Jump to mark M          |
| `<leader>jt` | Jump to mark T          |
| `<leader>jb` | Jump to mark B          |
| `<leader>js` | Jump to mark S          |
| `<leader>jf` | Jump to mark F          |
| `<leader>j.` | Jump to marked position |
| `<leader>jr` | Return to mark          |

### Jump to Marks (Exact Position)

| Keybinding   | Action               |
| ------------ | -------------------- |
| `<leader>gm` | Go to mark M (exact) |
| `<leader>gt` | Go to mark T (exact) |
| `<leader>gb` | Go to mark B (exact) |
| `<leader>gs` | Go to mark S (exact) |
| `<leader>gf` | Go to mark F (exact) |

### Project Bookmarks

| Keybinding   | Action                        |
| ------------ | ----------------------------- |
| `<leader>bm` | Set bookmark: Main file (M)   |
| `<leader>bc` | Set bookmark: Config file (C) |
| `<leader>bt` | Set bookmark: Test file (T)   |
| `<leader>br` | Set bookmark: README file (R) |
| `<leader>Bm` | Go to Main bookmark           |
| `<leader>Bc` | Go to Config bookmark         |
| `<leader>Bt` | Go to Test bookmark           |
| `<leader>Br` | Go to README bookmark         |

### Recent File Marks

| Keybinding   | Action                     |
| ------------ | -------------------------- |
| `<leader>j0` | Jump to last exit position |
| `<leader>j1` | Jump to recent file 1      |
| `<leader>j2` | Jump to recent file 2      |
| `<leader>j3` | Jump to recent file 3      |

### Automatic Marks

| Keybinding   | Action                         |
| ------------ | ------------------------------ |
| `<leader>j`` | Jump to last jump position     |
| `<leader>j'` | Jump to last jump line         |
| `<leader>j"` | Jump to last exit position     |
| `<leader>j^` | Jump to last insert position   |
| `<leader>j.` | Jump to last change position   |
| `<leader>j[` | Jump to change/yank start      |
| `<leader>j]` | Jump to change/yank end        |
| `<leader>j<` | Jump to visual selection start |
| `<leader>j>` | Jump to visual selection end   |

### Mark Management

| Keybinding    | Action                         |
| ------------- | ------------------------------ |
| `<leader>ml`  | List all marks                 |
| `<leader>md`  | Delete specific marks (prompt) |
| `<leader>mD`  | Delete all lowercase marks     |
| `<leader>mCa` | Clear all local marks (a-z)    |
| `<leader>mCA` | Clear all global marks (A-Z)   |
| `<leader>mC0` | Clear all numbered marks (0-9) |

### Enhanced Mark Actions

| Keybinding   | Action                       |
| ------------ | ---------------------------- |
| `<leader>mM` | Set mark M with feedback     |
| `<leader>mT` | Set mark T with feedback     |
| `<leader>mB` | Set mark B with feedback     |
| `<leader>JM` | Jump to mark M with feedback |
| `<leader>JT` | Jump to mark T with feedback |
| `<leader>JB` | Jump to mark B with feedback |

### Search with Marks

| Keybinding | Action                            |
| ---------- | --------------------------------- |
| `/`        | Search (marks position)           |
| `?`        | Search backwards (marks position) |

### Telescope Integration

| Keybinding   | Action                    |
| ------------ | ------------------------- |
| `<leader>fm` | Find marks with Telescope |

---

## 📍 Jump and Change Lists

Navigate through previous positions and changes.

| Keybinding   | Action                 |
| ------------ | ---------------------- |
| `Ctrl+o`     | Jump to older position |
| `Ctrl+i`     | Jump to newer position |
| `<leader>jo` | Show jump list         |
| `g;`         | Go to older change     |
| `g,`         | Go to newer change     |
| `<leader>jc` | Show change list       |

---

## 🛠️ Commands

Useful commands for marks and navigation.

| Command          | Action                |
| ---------------- | --------------------- |
| `:ShowMarks`     | Show all marks        |
| `:ClearMarks`    | Clear all local marks |
| `:ClearAllMarks` | Clear all marks       |
| `:MarkInfo`      | Show mark information |

---

**Tips for AuDHD Users**:

- **Focus**: Use `<leader>zi` to check fold status or `<leader>ml` for marks when overwhelmed.
- **Consistency**: `<leader>` prefix is consistent; group similar actions (e.g., `<leader>t*` for tabs).
- **Feedback**: Use enhanced mark commands (`<leader>mM`, `<leader>JM`) for visual confirmation.
- **Simplify**: Try `<leader>zfc` to toggle fold column for visual cues or `<leader>zt` to toggle folding.

```py
print("hi")
a = 56
```
