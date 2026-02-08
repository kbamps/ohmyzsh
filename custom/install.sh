#!/bin/bash
#
# Custom Oh My Zsh Installation Script
# Repository: https://github.com/kbamps/ohmyzsh
#
# Installation instructions:
#   git clone https://github.com/kbamps/ohmyzsh.git ~/.oh-my-zsh
#   bash ~/.oh-my-zsh/custom/install.sh
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Installing custom Oh My Zsh configuration...${NC}"
echo

# Check if we're in the right directory
if [[ ! -f "$HOME/.oh-my-zsh/custom/install.sh" ]]; then
    echo -e "${RED}Error: Oh My Zsh repository not found at ~/.oh-my-zsh${NC}"
    echo "Please clone the repository first:"
    echo "  git clone https://github.com/kbamps/ohmyzsh.git ~/.oh-my-zsh"
    exit 1
fi

# Backup existing .zshrc if present
if [[ -f "$HOME/.zshrc" ]]; then
    backup_file="$HOME/.zshrc.backup-$(date +%Y%m%d-%H%M%S)"
    echo -e "${YELLOW}Backing up existing .zshrc to ${backup_file}${NC}"
    cp "$HOME/.zshrc" "$backup_file"
fi

# Copy template with custom theme already set
echo -e "${GREEN}Installing .zshrc with agnoster-custom theme...${NC}"
cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"

# Change default shell to zsh
echo
echo -e "${BLUE}Changing default shell to zsh...${NC}"
if command -v zsh >/dev/null 2>&1; then
    zsh_path=$(which zsh)
    
    # Check if zsh is in /etc/shells
    if ! grep -q "^$zsh_path$" /etc/shells 2>/dev/null; then
        echo -e "${YELLOW}Warning: $zsh_path is not in /etc/shells${NC}"
        echo "You may need to add it manually with:"
        echo "  sudo sh -c \"echo $zsh_path >> /etc/shells\""
    fi
    
    if [[ "$SHELL" != "$zsh_path" ]]; then
        echo "Attempting to change shell to: $zsh_path"
        if chsh -s "$zsh_path" 2>/dev/null; then
            echo -e "${GREEN}Shell changed successfully${NC}"
        else
            echo -e "${YELLOW}Could not change shell automatically${NC}"
            echo "Run this command manually:"
            echo "  chsh -s $zsh_path"
        fi
    else
        echo -e "${GREEN}Zsh is already your default shell${NC}"
    fi
else
    echo -e "${RED}Error: zsh not found. Please install zsh first.${NC}"
    exit 1
fi

echo
echo -e "${GREEN}✓ Installation complete!${NC}"
echo
echo "Next steps:"
echo "  1. Logout and login again (or start a new terminal session)"
echo "  2. Run: ${YELLOW}install_dotfiles${NC} to install .screenrc and other dotfiles"
echo "  3. Customize your environment with:"
echo "     - ${YELLOW}add_alias <name> <command>${NC}"
echo "     - ${YELLOW}add_env <NAME> <value>${NC}"
echo
echo "To use zsh now without logging out, run:"
echo "  ${YELLOW}exec zsh${NC}"
echo
