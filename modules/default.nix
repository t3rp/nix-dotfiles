{
  # This file aggregates all module imports for cleaner organization
  # Instead of importing each module individually in home.nix do it here
  
  imports = [
    ./git.nix
    ./general.nix
    ./tmux.nix
    ./shell.nix
    ./ssh.nix
  ];
}
