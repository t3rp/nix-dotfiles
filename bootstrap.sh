#!/usr/bin/env bash

# Usage:
#   curl -L https://raw.githubusercontent.com/t3rp/nix-dotfiles/main/bootstrap.sh | bash
#   ./bootstrap.sh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration variables
DOTFILES_REPO="https://github.com/t3rp/nix-dotfiles.git"
DOTFILES_DIR="$HOME/Development/nix-dotfiles"
USERNAME="${USER}"  # Automatically use current username

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Prompt user for confirmation
confirm() {
    local prompt="$1"
    local default="${2:-n}"
    local response
    
    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi
    
    read -p "$prompt" response
    response=${response:-$default}
    
    [[ "$response" =~ ^[Yy]$ ]]
}

echo -e "${RED}"
cat << "EOF"

 ███████████  ████████  ███████████   ███████████   ██  █████████ 
░█░░░███░░░█ ███░░░░███░░███░░░░░███ ░░███░░░░░███ ███ ███░░░░░███
░   ░███  ░ ░░░    ░███ ░███    ░███  ░███    ░███░░░ ░███    ░░░ 
    ░███       ██████░  ░██████████   ░██████████     ░░█████████ 
    ░███      ░░░░░░███ ░███░░░░░███  ░███░░░░░░       ░░░░░░░░███
    ░███     ███   ░███ ░███    ░███  ░███             ███    ░███
    █████   ░░████████  █████   █████ █████           ░░█████████ 
   ░░░░░     ░░░░░░░░  ░░░░░   ░░░░░ ░░░░░             ░░░░░░░░░  

Home Manager Bootstrap Script...

EOF
echo -e "${NC}"

# Step 1: Check and install Nix
log_info "Step 1/5: Checking for Nix installation..."

if command_exists nix; then
    log_success "Nix is already installed"
    nix --version
else
    log_warning "Nix is not installed"
    
    if confirm "Do you want to install Nix now?" "y"; then
        log_info "Installing Nix (multi-user installation)..."
        
        # Install Nix with flakes enabled from the start
        sh <(curl -L https://nixos.org/nix/install) --daemon --yes
        
        # Source nix for current session
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
        
        log_success "Nix installed successfully"
    else
        log_error "Nix is required. Please install it manually or run this script again."
        exit 1
    fi
fi

# Step 2: Enable Nix Flakes
log_info "Step 2/5: Configuring Nix with flakes support..."

NIX_CONFIG_DIR="$HOME/.config/nix"
NIX_CONFIG_FILE="$NIX_CONFIG_DIR/nix.conf"

# Create config directory if it doesn't exist
mkdir -p "$NIX_CONFIG_DIR"

# Check if flakes are already enabled
if [ -f "$NIX_CONFIG_FILE" ] && grep -q "experimental-features.*flakes" "$NIX_CONFIG_FILE"; then
    log_success "Nix flakes already enabled"
else
    log_info "Enabling Nix flakes and nix-command..."
    echo "experimental-features = nix-command flakes" >> "$NIX_CONFIG_FILE"
    log_success "Flakes enabled in $NIX_CONFIG_FILE"
fi

# Step 3: Install Git if needed
log_info "Step 3/5: Checking for Git installation..."

if ! command_exists git; then
    log_warning "Git is not installed"
    
    if confirm "Do you want to install Git via Nix?" "y"; then
        log_info "Installing Git..."
        nix-env -iA nixpkgs.git
        log_success "Git installed successfully"
    else
        log_error "Git is required to clone the dotfiles repository"
        exit 1
    fi
else
    log_success "Git is already installed"
fi

# Step 4: Clone or update dotfiles repository
log_info "Step 4/5: Setting up dotfiles repository..."

if [ -d "$DOTFILES_DIR" ]; then
    log_warning "Dotfiles directory already exists: $DOTFILES_DIR"
    
    if confirm "Do you want to update it (git pull)?" "y"; then
        log_info "Updating dotfiles repository..."
        cd "$DOTFILES_DIR"
        git pull
        log_success "Dotfiles repository updated"
    else
        log_info "Using existing dotfiles directory"
    fi
else
    log_info "Cloning dotfiles repository to $DOTFILES_DIR..."
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$DOTFILES_DIR")"
    
    # Clone the repository
    if [[ "$DOTFILES_REPO" == *"t3rp"* ]]; then
        log_warning "Repository URL not configured. Using local files instead."
        log_info "When pushing to a git repository, update DOTFILES_REPO in bootstrap.sh"
    else
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        log_success "Dotfiles repository cloned successfully"
    fi
fi

# Navigate to dotfiles directory
cd "$DOTFILES_DIR"

# Step 5: Apply Home Manager configuration
log_info "Step 5/5: Setting up Home Manager..."

# Update flake inputs
log_info "Updating flake inputs..."
nix flake update
log_success "Flake inputs updated and locked"
# Build and activate Home Manager configuration
log_info "Building and activating Home Manager configuration..."
log_warning "This may take several minutes on first run..."
# First time setup - need to use the home-manager from the flake
nix run home-manager/master -- switch --flake ".#$USERNAME"
log_success "Home Manager configuration activated!"
log_info "Configuration location: $DOTFILES_DIR"
log_info "To apply changes: cd $DOTFILES_DIR && home-manager switch --flake .#$USERNAME"
echo ""
