# Custom Oh-My-Zsh Configuration

This directory contains custom configurations for oh-my-zsh.

## Installation on a New Device

```bash
# 1. Clone the repository
git clone https://github.com/kbamps/ohmyzsh.git ~/.oh-my-zsh

# 2. Run the custom installer
bash ~/.oh-my-zsh/custom/install.sh

# 3. Start zsh (or logout/login to apply shell change)
exec zsh

# 4. Install dotfiles (optional)
install_dotfiles
```

## Files

- **themes/agnoster-custom.zsh-theme** - Custom Agnoster theme with abbreviated paths
- **functions.zsh** - Utility functions (cuda, add_env, add_alias, add_to_pythonpath, install_dotfiles)
- **dotfiles/** - Configuration files (.screenrc, etc.) - use `install_dotfiles` to copy them to `~`
- **env.zsh** - Server-specific environment variables (gitignored)
- **aliases.zsh** - Server-specific aliases (gitignored)

## Functions

### `add_env <NAME> <value>`
Add environment variables permanently to `env.zsh`

### `add_alias <name> <command>`
Add aliases permanently to `aliases.zsh`

### `add_to_pythonpath <path> [--permanent]`
Add directory to PYTHONPATH

### `install_dotfiles`
Install dotfiles from `custom/dotfiles/` to your home directory

### `cuda <device_ids>`
Set CUDA_VISIBLE_DEVICES for the current session
