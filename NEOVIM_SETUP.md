# Neovim Setup

This dotfiles repository uses [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) as the Neovim configuration.

## Installation

### 1. Install Neovim

Neovim is included in the base Brewfile and will be installed automatically during bootstrap. If you need to install it manually:

```bash
brew install neovim
```

### 2. Install Kickstart.nvim Configuration

Clone the forked kickstart.nvim repository to your Neovim config directory:

```bash
git clone https://github.com/elmartinez85/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

This will set up the configuration at `~/.config/nvim/`.

### 3. First Launch

When you first launch Neovim, it will automatically:
- Install the plugin manager (lazy.nvim)
- Download and install all configured plugins
- Set up LSP servers and other tools

Simply run:

```bash
nvim
```

The initial setup may take a minute or two to complete.

## Configuration Location

- **Neovim config**: `~/.config/nvim/`
- **Forked repository**: https://github.com/elmartinez85/kickstart.nvim
- **Upstream**: https://github.com/nvim-lua/kickstart.nvim

## Customization

To customize your Neovim setup:

1. Edit the configuration files in `~/.config/nvim/`
2. The main configuration is in `init.lua`
3. Additional configurations can be added in the `lua/` directory

## Updating

### Update Neovim itself:
```bash
brew upgrade neovim
```

### Update kickstart.nvim configuration:
```bash
cd ~/.config/nvim
git pull
```

### Update plugins within Neovim:
Inside Neovim, run:
```vim
:Lazy sync
```

## Useful Commands

- `:checkhealth` - Check Neovim and plugin health
- `:Lazy` - Open plugin manager UI
- `:Mason` - Manage LSP servers, linters, and formatters
- `:help kickstart` - View kickstart.nvim help documentation

## Aliases

The following aliases are available (from `.zsh_aliases`):

```bash
# Edit configuration files
nvimrc="nvim ~/.config/nvim/init.lua"
```

You may want to add this alias to your `.zsh_aliases` file for quick access to the config.

## Troubleshooting

If you encounter issues:

1. Run `:checkhealth` inside Neovim to diagnose problems
2. Delete the data directory and restart: `rm -rf ~/.local/share/nvim`
3. Reinstall plugins: Open Neovim and run `:Lazy sync`
4. Check the kickstart.nvim repository for updates and documentation

## Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Kickstart.nvim GitHub](https://github.com/nvim-lua/kickstart.nvim)
- [Your Fork](https://github.com/elmartinez85/kickstart.nvim)
