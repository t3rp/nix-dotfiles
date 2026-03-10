#!/usr/bin/env bash

# Usage:
#   curl -L https://raw.githubusercontent.com/YOUR_USERNAME/nix-dotfiles/main/bootstrap.sh | bash
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

# Clean up old Nix backup files before installation
cleanup_nix_backup() {
    local original="$1"
    local backup="${original}.backup-before-nix"
    
    # Skip if backup doesn't exist
    [ -f "$backup" ] || return 0
    
    log_warning "Found old backup: $backup"
    
    if confirm "Remove it to let Nix create a fresh backup?" "y"; then
        log_info "Creating safety backup in /tmp..."
        sudo cp "$backup" "/tmp/$(basename "$backup").$(date +%s)" 2>/dev/null || log_warning "Could not safeguard to /tmp"
        
        log_info "Removing: $backup"
        sudo rm "$backup"
        log_success "Removed $backup"
    else
        log_error "Cannot proceed. Please manually run: sudo rm $backup"
        return 1
    fi
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

# Step 1: Clean up old Nix backup files
log_info "Step 1/6: Checking for conflicting Nix backup files..."

# Array of rc files that Nix will try to back up
RC_FILES=(
    "/etc/bashrc"
    "/etc/bash.bashrc"
    "/etc/zshrc"
    "/etc/zsh/zshrc"
    "/etc/profile.d/nix.sh"
)

ALL_CLEANUP_SUCCESS=true
CLEANED_ANY=false

for rc_file in "${RC_FILES[@]}"; do
    if [ -f "${rc_file}.backup-before-nix" ]; then
        cleanup_nix_backup "$rc_file" || ALL_CLEANUP_SUCCESS=false
        CLEANED_ANY=true
    fi
done

if [ "$ALL_CLEANUP_SUCCESS" = false ]; then
    log_error "Cleanup of some backup files failed. Please resolve manually before continuing."
    exit 1
fi

if [ "$CLEANED_ANY" = true ]; then
    log_success "All conflicting backups cleaned up successfully"
else
    log_success "No conflicting backup files found"
fi

# Step 2: Check and install Nix
log_info "Step 2/6: Checking for Nix installation..."

if command_exists nix; then
    log_success "Nix is already installed"
    nix --version
else
    log_warning "Nix is not installed"
    
    if confirm "Do you want to install Nix now?" "y"; then
        log_info "Stopping any running Nix processes..."
        sudo systemctl stop nix-daemon.service 2>/dev/null || true
        sudo systemctl stop nix-daemon.socket 2>/dev/null || true
        sleep 2
        
        log_info "Installing Nix (multi-user installation)..."
        
        # Install Nix with flakes enabled from the start
        sh <(curl -L https://nixos.org/nix/install) --daemon --yes
        
        # Source nix for current session - try multiple approaches
        log_info "Setting up Nix environment in current shell..."
        
        # Try the standard nix-daemon profile
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
        
        # If nix still not found, manually add to PATH
        if ! command_exists nix; then
            log_info "Manually adding Nix to PATH..."
            export PATH="/nix/var/nix/profiles/default/bin:$PATH"
            export PATH="/nix/var/nix/profiles/default/sbin:$PATH"
        fi
        
        # Verify nix is now available
        if command_exists nix; then
            log_success "Nix installed successfully"
            nix --version
        else
            log_error "Nix installation completed but nix command not found in PATH"
            log_error "Please restart your shell or run: source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
            exit 1
        fi
    else
        log_error "Nix is required. Please install it manually or run this script again."
        exit 1
    fi
fi

# Step 3: Enable Nix Flakes
log_info "Step 3/6: Configuring Nix with flakes support..."

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

# Step 4: Install Git if needed
log_info "Step 4/6: Checking for Git installation..."

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

# Step 5: Clone or update dotfiles repository
log_info "Step 5/6: Setting up dotfiles repository..."

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
    if [[ "$DOTFILES_REPO" == *"YOUR_USERNAME"* ]]; then
        log_warning "Repository URL not configured. Using local files instead."
        log_info "When pushing to a git repository, update DOTFILES_REPO in bootstrap.sh"
    else
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        log_success "Dotfiles repository cloned successfully"
    fi
fi

# Navigate to dotfiles directory
cd "$DOTFILES_DIR"

# Step 6: Apply Home Manager configuration
log_info "Step 6/6: Setting up Home Manager..."

# Update username in configuration files if needed
log_info "Checking username configuration..."

# Check if username in home.nix matches current user
if grep -q "username = \"$USERNAME\"" home.nix; then
    log_success "Username already configured correctly: $USERNAME"
else
    log_warning "Updating username in configuration files to: $USERNAME"
    
    # This is a simple sed replacement - in a real scenario you might want to be more careful
    if [ "$(uname)" = "Darwin" ]; then
        # macOS
        sed -i '' "s/username = \".*\"/username = \"$USERNAME\"/" home.nix
        sed -i '' "s/homeDirectory = \".*\"/homeDirectory = \"$HOME\"/" home.nix
    else
        # Linux
        sed -i "s/username = \".*\"/username = \"$USERNAME\"/" home.nix
        sed -i "s/homeDirectory = \".*\"/homeDirectory = \"$HOME\"/" home.nix
    fi
    
    log_info "Please verify the configuration in home.nix and flake.nix"
fi

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
