{
  # This file aggregates all module imports for cleaner organization
  # Instead of importing each module individually in home.nix,
  # you can import this file which imports all modules automatically
  #
  # Usage in home.nix:
  #   imports = [ ./modules ];
  #
  # This is optional - you can also import modules individually as shown
  # in the current home.nix configuration. Use whichever approach you prefer.
  
  imports = [
    ./git.nix
  ];
}
